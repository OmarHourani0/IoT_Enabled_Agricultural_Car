void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
}
unsigned char Check;

void StartSignal() {
    TRISB |= 0x04; // Configure RB2 as output
    PORTB &= ~0x04; // RB2 sends 0 to the sensor
    our_delay_ms(18);
    PORTB |= 0x04; // RB2 sends 1 to the sensor
    delay_us(30);
    TRISB &= ~0x04; // Configure RB2 as input
}

void CheckResponse() {
    Check = 0;
    delay_us(40);
    if (!(PORTB & 0x04)) {
        delay_us(80);
        if (PORTB & 0x04) Check = 1;
        delay_us(40);
    }
}

char ReadData() {
    char i, j;
    for (j = 0; j < 8; j++) {
        while (!(PORTB & 0x04)); // Wait until RB2 goes HIGH
        delay_us(30);
        if (!(PORTB & 0x04)) {
            i &= ~(1 << (7 - j)); // Clear bit (7-b)
        } else {
            i |= (1 << (7 - j)); // Set bit (7-b)
            while (PORTB & 0x04); // Wait until RB2 goes LOW
        }
    }
    return i;
}


// PORTA --> A0 LDR, A1 moisture sensor, A2 PH sensor, A3 on LM35, A4 to A7 xxx; All inputs; TRISA = 0xFF
// PORTB --> B0 TRIG (ultrasonic), B1 ECHO (ultrasonic),B2 and B3 xxx, B4 to B7 buttons; 0000,0110; TRISB = 0x06
// PORTC --> C0 and C1 xxx, C2 PWM Servo, C3 to C5 xxx, C6 Tx BLE, C7 Rx BLE; All outputs except C6; TRISC = 0x40
// PORTD --> D0 to D3 LEDs, D4 to D7 Motors; All outputs; TRISD = 0x00


void setup(){
    /// MY CODE
    //  TRISC = 0xFF;
    //  TRISB = 0x02;
    //  PORTC = 0x00;
    //  PORTB = 0x00;
    //  our_delay_ms(100);

    TRISA = 0xFF;
    TRISB = 0x06;
    TRISC = 0x40;
    TRISD = 0x00;
    PORTA = 0x00;  // Initialize PORTB
    PORTB = 0x00;  // Initialize PORTB
    PORTC = 0x00;  // Initialize PORTC
    PORTD = 0x00;  // Initialize PORTD
    ADCON0 = 0x00; // MAKE IT 0x01 before using A/D
    ADCON1 = 0x00; // Configure ADC module
    // Configure USART
    PIR1 = 0x00;   // Set all interrupt flags to zero
    INTCON = 0x00;
    our_delay_ms(100);
}

void trigger_pulse(){
    PORTB = 0x01;  // Set Trigger pin high
    delay_us(10);  // 10us pulse
    PORTB = 0x00;  // Set Trigger pin low
}

unsigned int measure_distance(){
    unsigned int time = 0;
    unsigned int timeout;

    trigger_pulse();

    // Wait for echo signal to go HIGH
    timeout = 0xFFFF;
    while (!(PORTB & 0x02)) {
        if (--timeout == 0) {
            return 0;  // Timeout prevention, no object detected
        }
    }

    // Start Timer1
    TMR1H = 0;
    TMR1L = 0;
    T1CON = 0x01;  // Enable Timer1 with no prescaler

    // Wait for echo signal to go LOW
    timeout = 0xFFFF;
    while (PORTB & 0x02) {
        if (--timeout == 0) {
            T1CON = 0x00;  // Disable Timer1
            return 0;  // Timeout prevention
        }
    }

    // Stop Timer1 and calculate time
    T1CON = 0x00;  // Disable Timer1
    time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes

    // Convert time to distance in cm
    return time / 58;
}

unsigned int LDR(){
    unsigned int res = 0;
    ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
    ADCON0 = 0x01; // A/D on, channel 0, go done is 0
    ADRESH = 0x00; // Clear Ananlog Result Values
    ADRESL = 0x00; // Clear Ananlog Result Values
    Delay_us(10);
    ADCON0 = 0x05; // A/D on, channel 0, go done is 1

    while(ADCON0 & 0x04); // stay in loop until conversion is done

    ADCON0 = ADCON0 & 0xFE;

    res = (ADRESH << 8) | ADRESL; // save result

    return res;
}

unsigned int moist(){
    unsigned int res = 0;
    ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
    ADCON0 = 0x09; // A/D on, channel 1, go done is 0
    ADRESH = 0x00; // Clear Ananlog Result Values
    ADRESL = 0x00; // Clear Ananlog Result Values
    Delay_us(10);
    ADCON0 = 0x0D; // A/D on, channel 1, go done is 1

    while(ADCON0 & 0x04); // stay in loop until conversion is done

    ADCON0 = ADCON0 & 0xF6;

    res = (ADRESH << 8) | ADRESL; // save result

    return res;
}

unsigned int read_ph(){
    unsigned int res = 0;
    ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
    ADCON0 = 0x11; //A/D on, channel 2, go done is 0
    ADRESH = 0x00; // Clear Ananlog Result Values
    ADRESL = 0x00; // Clear Ananlog Result Values
    Delay_us(10);
    ADCON0 = 0x15;

    while(ADCON0 & 0x04); // stay in loop until conversion is done

    ADCON0 = ADCON0 & 0xEE;
    res = (ADRESH << 8) | ADRESL; // save result

    return res;
}

float calculate_ph(unsigned int adc_value) {
    // Convert ADC value to voltage (assuming 10-bit ADC and 5V reference)
    float voltage = (adc_value * 5.1) / 1023.0;

    // Convert voltage to pH (neutral pH 7 corresponds to 2.5V)
    float ph = (5.22 - voltage) / 0.153;

    return ph;
}

float calculate_ph_v(unsigned int adc_value) {
    // Convert ADC value to voltage (assuming 10-bit ADC and 5V reference)
    float voltage = (adc_value * 5.0) / 1023.0;

    // Convert voltage to pH (neutral pH 7 corresponds to 2.5V)
    float ph = (5.22 - voltage) / 0.153;

    return voltage;
}

unsigned int read_lm35() {
    unsigned int adc_value = 0;
    float voltage = 0.0;
    unsigned int temperature_C = 0;

    ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports analog, Vref = Vdd
    ADCON0 = 0x19; // Select channel 3 (A3), A/D ON
    ADRESH = 0x00; // Clear previous result
    ADRESL = 0x00; // Clear previous result
    delay_us(10);   // Allow acquisition time
    ADCON0 |= 0x04; // Start conversion

    while (ADCON0 & 0x04); // Wait for conversion to finish

    // Combine high and low bytes to get 10-bit ADC value
    adc_value = (ADRESH << 8) | ADRESL;

    // Convert ADC value to voltage (Assumes 10-bit ADC and 5V reference)
    voltage = (adc_value * 5.0) / 1023.0;

    // Convert voltage to temperature (LM35 outputs 10 mV per degree Celsius)
    temperature_C = voltage * 100;

    return temperature_C;
}

void bluetooth_init() {
    UART1_Init(9600);
     our_delay_ms(100);   // Initialize UART with 9600 baud rate
}

void pwm_init() {
    // Configure CCP1 module for PWM (for servo on RC2)
    CCP1CON = 0x0C; // Set CCP1M3 and CCP1M2 to 1, rest bits remain as they are

    T2CON = T2CON | 0x07;// Set T2CKPS1, T2CKPS0, and TMR2ON to 1

    PR2 = 249; // Set period register for 50Hz frequency
}

void set_servo_position1(int degrees) {
    int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
    CCPR1L = pulse_width >> 2; // Set CCPR1L register
    CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
    our_delay_ms(50*4); // Delay for the servo to reach the desired position
    PORTD = 0x00;
}

void send_sensor_data(unsigned int distance, unsigned int ldr_value, unsigned int moist_value, unsigned int temperature) {
    char buffer[16];

    // Send distance data
    //UART1_Write_Text("\nDistance: ");
    IntToStr(distance, buffer);   // Convert integer to string
    UART1_Write_Text(buffer);
    UART1_Write_Text(",");

    // Send LDR value
    //UART1_Write_Text("LDR Value: ");
    IntToStr(ldr_value, buffer); // Convert integer to string
    UART1_Write_Text(buffer);
    UART1_Write_Text(",");

    // Send moisture sensor value
    //UART1_Write_Text("Moisture: ");
    IntToStr(moist_value, buffer); // Convert integer to string
    UART1_Write_Text(buffer);
    UART1_Write_Text(",");

    IntToStr(temperature, buffer);
    UART1_Write_Text(buffer);
    UART1_Write_Text(",");

    our_delay_ms(200);

}

void send_PH_data(unsigned int ph){
     char buffer[16];
     FloatToStr(ph, buffer);   // Convert integer to string
     UART1_Write_Text(buffer);
}

void forward(){
    PORTD = 0x91;
    our_delay_ms(100);
}

void backward(){
     PORTD = 0x62;
     our_delay_ms(100);
}

void left(){
     PORTD = 0xA4;
     our_delay_ms(100);
}

void right(){
     PORTD = 0x58;
     our_delay_ms(100);
}

void stop(){
     PORTD = 0x00;
     our_delay_ms(200);
}

void led_on(){
     PORTD = 0x0F;
     our_delay_ms(300);
}

void led_mid_on(){
     PORTD = 0x06;
     our_delay_ms(300);
}

void led_outer_on(){
     PORTD = 0x09;
     our_delay_ms(300);
}

void main() {
     unsigned int distance;
     unsigned int ldr_value;
     unsigned int moist_value;
     unsigned int ph_adc_value;
     unsigned int temperature;
     unsigned char received_data;
     float ph;
     float ph_v;


     setup();
     bluetooth_init();
     pwm_init();
     UART1_Write_Text("System Start\r\n"); // Send a startup message

     while(1){
        distance = measure_distance();
        ldr_value = LDR();
        moist_value = moist();
        temperature = read_lm35(); // Read temperature from LM35
        ph_adc_value = read_ph();  // Read the analog value from the sensor
        ph = calculate_ph(ph_adc_value);  // Convert ADC value to pH
        //ph_v = calculate_ph_v(ph_adc_value);  // Convert ADC value to pH

        StartSignal();
        CheckResponse();

       if (UART1_Data_Ready()) {
            //our_delay_ms(100);
            received_data = UART1_Read();  // Read the received data

            //UART1_Write(received_data);   // Echo back the received data (for testing)
            if(received_data == 'F'){
              forward();
            } else if(received_data == 'B'){
              backward();
            } else if (received_data == 'D'){
              send_sensor_data(distance, ldr_value, moist_value, temperature);
              send_PH_data(ph);
              UART1_Write_Text("\r\n\n");
              our_delay_ms(200) ;
            } else if (received_data == 'W'){
              UART1_Write_Text("\nDistance, LDR, Moist, Temp, PH");
              UART1_Write_Text("\r\n\n");
            } else if (received_data == 'S'){
              set_servo_position1(90);
              our_delay_ms(500);
              set_servo_position1(-90);
              set_servo_position1(0);
            } else if (received_data == 'L'){
              right();
            } else if (received_data == 'R'){
              left();
            } else if (received_data == 'O'){
              led_on();
            } else if (received_data == 'X'){
              led_on();
              stop();
            } else {
              UART1_Write_Text("\nI hate my life\r\n\n");
            }
        }

        // PORTB & 0x10 --> Forward
        // PORTB & 0x20 --> Backward
        // PORTB & 0x40 --> Left
        // PORTB & 0x80 --> Right
        // ldr_value > 700 --> When dark = 1
        // moist_value < 560 --> When in water = 1
        // distance < 30 --> = 1 when closer than 30cm
        /*
        if (moist_value < 560){
              led_mid_on();
        } else if(ldr_value > 700){
              led_outer_on();
        } else if(distance < 30){
              led_mid_on();
        } else{
               stop();
        }
        */


     }
}
