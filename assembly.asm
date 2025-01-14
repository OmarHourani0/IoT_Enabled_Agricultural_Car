
_our_delay_ms:

;hbridgetest2.c,4 ::                 void our_delay_ms(unsigned int ms) {
;hbridgetest2.c,6 ::                 for (i = 0; i < ms; i++) {
        CLRF       R1+0
        CLRF       R1+1
L_our_delay_ms0:
        MOVF       FARG_our_delay_ms_ms+1, 0
        SUBWF      R1+1, 0
        BTFSS      STATUS+0, 2
        GOTO       L__our_delay_ms63
        MOVF       FARG_our_delay_ms_ms+0, 0
        SUBWF      R1+0, 0
L__our_delay_ms63:
        BTFSC      STATUS+0, 0
        GOTO       L_our_delay_ms1
;hbridgetest2.c,7 ::                 for (j = 0; j < 111; j++) NOP();
        CLRF       R3+0
        CLRF       R3+1
L_our_delay_ms3:
        MOVLW      0
        SUBWF      R3+1, 0
        BTFSS      STATUS+0, 2
        GOTO       L__our_delay_ms64
        MOVLW      111
        SUBWF      R3+0, 0
L__our_delay_ms64:
        BTFSC      STATUS+0, 0
        GOTO       L_our_delay_ms4
        NOP
        INCF       R3+0, 1
        BTFSC      STATUS+0, 2
        INCF       R3+1, 1
        GOTO       L_our_delay_ms3
L_our_delay_ms4:
;hbridgetest2.c,6 ::                 for (i = 0; i < ms; i++) {
        INCF       R1+0, 1
        BTFSC      STATUS+0, 2
        INCF       R1+1, 1
;hbridgetest2.c,8 ::                 }
        GOTO       L_our_delay_ms0
L_our_delay_ms1:
;hbridgetest2.c,9 ::                 }
L_end_our_delay_ms:
        RETURN
; end of _our_delay_ms

_StartSignal:

;hbridgetest2.c,12 ::                 void StartSignal() {
;hbridgetest2.c,13 ::                 TRISB |= 0x04; // Configure RB2 as output
        BSF        TRISB+0, 2
;hbridgetest2.c,14 ::                 PORTB &= ~0x04; // RB2 sends 0 to the sensor
        BCF        PORTB+0, 2
;hbridgetest2.c,15 ::                 our_delay_ms(18);
        MOVLW      18
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,16 ::                 PORTB |= 0x04; // RB2 sends 1 to the sensor
        BSF        PORTB+0, 2
;hbridgetest2.c,17 ::                 delay_us(30);
        MOVLW      19
        MOVWF      R13+0
L_StartSignal6:
        DECFSZ     R13+0, 1
        GOTO       L_StartSignal6
        NOP
        NOP
;hbridgetest2.c,18 ::                 TRISB &= ~0x04; // Configure RB2 as input
        BCF        TRISB+0, 2
;hbridgetest2.c,19 ::                 }
L_end_StartSignal:
        RETURN
; end of _StartSignal

_CheckResponse:

;hbridgetest2.c,21 ::                 void CheckResponse() {
;hbridgetest2.c,22 ::                 Check = 0;
        CLRF       _Check+0
;hbridgetest2.c,23 ::                 delay_us(40);
        MOVLW      26
        MOVWF      R13+0
L_CheckResponse7:
        DECFSZ     R13+0, 1
        GOTO       L_CheckResponse7
        NOP
;hbridgetest2.c,24 ::                 if (!(PORTB & 0x04)) {
        BTFSC      PORTB+0, 2
        GOTO       L_CheckResponse8
;hbridgetest2.c,25 ::                 delay_us(80);
        MOVLW      53
        MOVWF      R13+0
L_CheckResponse9:
        DECFSZ     R13+0, 1
        GOTO       L_CheckResponse9
;hbridgetest2.c,26 ::                 if (PORTB & 0x04) Check = 1;
        BTFSS      PORTB+0, 2
        GOTO       L_CheckResponse10
        MOVLW      1
        MOVWF      _Check+0
L_CheckResponse10:
;hbridgetest2.c,27 ::                 delay_us(40);
        MOVLW      26
        MOVWF      R13+0
L_CheckResponse11:
        DECFSZ     R13+0, 1
        GOTO       L_CheckResponse11
        NOP
;hbridgetest2.c,28 ::                 }
L_CheckResponse8:
;hbridgetest2.c,29 ::                 }
L_end_CheckResponse:
        RETURN
; end of _CheckResponse

_ReadData:

;hbridgetest2.c,31 ::                 char ReadData() {
;hbridgetest2.c,33 ::                 for (j = 0; j < 8; j++) {
        CLRF       R3+0
L_ReadData12:
        MOVLW      8
        SUBWF      R3+0, 0
        BTFSC      STATUS+0, 0
        GOTO       L_ReadData13
;hbridgetest2.c,34 ::                 while (!(PORTB & 0x04)); // Wait until RB2 goes HIGH
L_ReadData15:
        BTFSC      PORTB+0, 2
        GOTO       L_ReadData16
        GOTO       L_ReadData15
L_ReadData16:
;hbridgetest2.c,35 ::                 delay_us(30);
        MOVLW      19
        MOVWF      R13+0
L_ReadData17:
        DECFSZ     R13+0, 1
        GOTO       L_ReadData17
        NOP
        NOP
;hbridgetest2.c,36 ::                 if (!(PORTB & 0x04)) {
        BTFSC      PORTB+0, 2
        GOTO       L_ReadData18
;hbridgetest2.c,37 ::                 i &= ~(1 << (7 - j)); // Clear bit (7-b)
        MOVF       R3+0, 0
        SUBLW      7
        MOVWF      R0+0
        MOVF       R0+0, 0
        MOVWF      R1+0
        MOVLW      1
        MOVWF      R0+0
        MOVF       R1+0, 0
L__ReadData68:
        BTFSC      STATUS+0, 2
        GOTO       L__ReadData69
        RLF        R0+0, 1
        BCF        R0+0, 0
        ADDLW      255
        GOTO       L__ReadData68
L__ReadData69:
        COMF       R0+0, 1
        MOVF       R0+0, 0
        ANDWF      R2+0, 1
;hbridgetest2.c,38 ::                 } else {
        GOTO       L_ReadData19
L_ReadData18:
;hbridgetest2.c,39 ::                 i |= (1 << (7 - j)); // Set bit (7-b)
        MOVF       R3+0, 0
        SUBLW      7
        MOVWF      R0+0
        MOVF       R0+0, 0
        MOVWF      R1+0
        MOVLW      1
        MOVWF      R0+0
        MOVF       R1+0, 0
L__ReadData70:
        BTFSC      STATUS+0, 2
        GOTO       L__ReadData71
        RLF        R0+0, 1
        BCF        R0+0, 0
        ADDLW      255
        GOTO       L__ReadData70
L__ReadData71:
        MOVF       R0+0, 0
        IORWF      R2+0, 1
;hbridgetest2.c,40 ::                 while (PORTB & 0x04); // Wait until RB2 goes LOW
L_ReadData20:
        BTFSS      PORTB+0, 2
        GOTO       L_ReadData21
        GOTO       L_ReadData20
L_ReadData21:
;hbridgetest2.c,41 ::                 }
L_ReadData19:
;hbridgetest2.c,33 ::                 for (j = 0; j < 8; j++) {
        INCF       R3+0, 1
;hbridgetest2.c,42 ::                 }
        GOTO       L_ReadData12
L_ReadData13:
;hbridgetest2.c,43 ::                 return i;
        MOVF       R2+0, 0
        MOVWF      R0+0
;hbridgetest2.c,44 ::                 }
L_end_ReadData:
        RETURN
; end of _ReadData

_setup:

;hbridgetest2.c,53 ::                 void setup(){
;hbridgetest2.c,61 ::                 TRISA = 0xFF;
        MOVLW      255
        MOVWF      TRISA+0
;hbridgetest2.c,62 ::                 TRISB = 0x06;
        MOVLW      6
        MOVWF      TRISB+0
;hbridgetest2.c,63 ::                 TRISC = 0x40;
        MOVLW      64
        MOVWF      TRISC+0
;hbridgetest2.c,64 ::                 TRISD = 0x00;
        CLRF       TRISD+0
;hbridgetest2.c,65 ::                 PORTA = 0x00;  // Initialize PORTB
        CLRF       PORTA+0
;hbridgetest2.c,66 ::                 PORTB = 0x00;  // Initialize PORTB
        CLRF       PORTB+0
;hbridgetest2.c,67 ::                 PORTC = 0x00;  // Initialize PORTC
        CLRF       PORTC+0
;hbridgetest2.c,68 ::                 PORTD = 0x00;  // Initialize PORTD
        CLRF       PORTD+0
;hbridgetest2.c,69 ::                 ADCON0 = 0x00; // MAKE IT 0x01 before using A/D
        CLRF       ADCON0+0
;hbridgetest2.c,70 ::                 ADCON1 = 0x00; // Configure ADC module
        CLRF       ADCON1+0
;hbridgetest2.c,72 ::                 PIR1 = 0x00;   // Set all interrupt flags to zero
        CLRF       PIR1+0
;hbridgetest2.c,73 ::                 INTCON = 0x00;
        CLRF       INTCON+0
;hbridgetest2.c,74 ::                 our_delay_ms(100);
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,75 ::                 }
L_end_setup:
        RETURN
; end of _setup

_trigger_pulse:

;hbridgetest2.c,77 ::                 void trigger_pulse(){
;hbridgetest2.c,78 ::                 PORTB = 0x01;  // Set Trigger pin high
        MOVLW      1
        MOVWF      PORTB+0
;hbridgetest2.c,79 ::                 delay_us(10);  // 10us pulse
        MOVLW      6
        MOVWF      R13+0
L_trigger_pulse22:
        DECFSZ     R13+0, 1
        GOTO       L_trigger_pulse22
        NOP
;hbridgetest2.c,80 ::                 PORTB = 0x00;  // Set Trigger pin low
        CLRF       PORTB+0
;hbridgetest2.c,81 ::                 }
L_end_trigger_pulse:
        RETURN
; end of _trigger_pulse

_measure_distance:

;hbridgetest2.c,83 ::                 unsigned int measure_distance(){
;hbridgetest2.c,84 ::                 unsigned int time = 0;
;hbridgetest2.c,87 ::                 trigger_pulse();
        CALL       _trigger_pulse+0
;hbridgetest2.c,90 ::                 timeout = 0xFFFF;
        MOVLW      255
        MOVWF      measure_distance_timeout_L0+0
        MOVLW      255
        MOVWF      measure_distance_timeout_L0+1
;hbridgetest2.c,91 ::                 while (!(PORTB & 0x02)) {
L_measure_distance23:
        BTFSC      PORTB+0, 1
        GOTO       L_measure_distance24
;hbridgetest2.c,92 ::                 if (--timeout == 0) {
        MOVLW      1
        SUBWF      measure_distance_timeout_L0+0, 1
        BTFSS      STATUS+0, 0
        DECF       measure_distance_timeout_L0+1, 1
        MOVLW      0
        XORWF      measure_distance_timeout_L0+1, 0
        BTFSS      STATUS+0, 2
        GOTO       L__measure_distance75
        MOVLW      0
        XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance75:
        BTFSS      STATUS+0, 2
        GOTO       L_measure_distance25
;hbridgetest2.c,93 ::                 return 0;  // Timeout prevention, no object detected
        CLRF       R0+0
        CLRF       R0+1
        GOTO       L_end_measure_distance
;hbridgetest2.c,94 ::                 }
L_measure_distance25:
;hbridgetest2.c,95 ::                 }
        GOTO       L_measure_distance23
L_measure_distance24:
;hbridgetest2.c,98 ::                 TMR1H = 0;
        CLRF       TMR1H+0
;hbridgetest2.c,99 ::                 TMR1L = 0;
        CLRF       TMR1L+0
;hbridgetest2.c,100 ::                 T1CON = 0x01;  // Enable Timer1 with no prescaler
        MOVLW      1
        MOVWF      T1CON+0
;hbridgetest2.c,103 ::                 timeout = 0xFFFF;
        MOVLW      255
        MOVWF      measure_distance_timeout_L0+0
        MOVLW      255
        MOVWF      measure_distance_timeout_L0+1
;hbridgetest2.c,104 ::                 while (PORTB & 0x02) {
L_measure_distance26:
        BTFSS      PORTB+0, 1
        GOTO       L_measure_distance27
;hbridgetest2.c,105 ::                 if (--timeout == 0) {
        MOVLW      1
        SUBWF      measure_distance_timeout_L0+0, 1
        BTFSS      STATUS+0, 0
        DECF       measure_distance_timeout_L0+1, 1
        MOVLW      0
        XORWF      measure_distance_timeout_L0+1, 0
        BTFSS      STATUS+0, 2
        GOTO       L__measure_distance76
        MOVLW      0
        XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance76:
        BTFSS      STATUS+0, 2
        GOTO       L_measure_distance28
;hbridgetest2.c,106 ::                 T1CON = 0x00;  // Disable Timer1
        CLRF       T1CON+0
;hbridgetest2.c,107 ::                 return 0;  // Timeout prevention
        CLRF       R0+0
        CLRF       R0+1
        GOTO       L_end_measure_distance
;hbridgetest2.c,108 ::                 }
L_measure_distance28:
;hbridgetest2.c,109 ::                 }
        GOTO       L_measure_distance26
L_measure_distance27:
;hbridgetest2.c,112 ::                 T1CON = 0x00;  // Disable Timer1
        CLRF       T1CON+0
;hbridgetest2.c,113 ::                 time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
        MOVF       TMR1H+0, 0
        MOVWF      R0+1
        CLRF       R0+0
        MOVF       TMR1L+0, 0
        IORWF      R0+0, 1
        MOVLW      0
        IORWF      R0+1, 1
;hbridgetest2.c,116 ::                 return time / 58;
        MOVLW      58
        MOVWF      R4+0
        MOVLW      0
        MOVWF      R4+1
        CALL       _Div_16X16_U+0
;hbridgetest2.c,117 ::                 }
L_end_measure_distance:
        RETURN
; end of _measure_distance

_LDR:

;hbridgetest2.c,119 ::                 unsigned int LDR(){
;hbridgetest2.c,120 ::                 unsigned int res = 0;
;hbridgetest2.c,121 ::                 ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
        MOVLW      192
        MOVWF      ADCON1+0
;hbridgetest2.c,122 ::                 ADCON0 = 0x01; // A/D on, channel 0, go done is 0
        MOVLW      1
        MOVWF      ADCON0+0
;hbridgetest2.c,123 ::                 ADRESH = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESH+0
;hbridgetest2.c,124 ::                 ADRESL = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESL+0
;hbridgetest2.c,125 ::                 Delay_us(10);
        MOVLW      6
        MOVWF      R13+0
L_LDR29:
        DECFSZ     R13+0, 1
        GOTO       L_LDR29
        NOP
;hbridgetest2.c,126 ::                 ADCON0 = 0x05; // A/D on, channel 0, go done is 1
        MOVLW      5
        MOVWF      ADCON0+0
;hbridgetest2.c,128 ::                 while(ADCON0 & 0x04); // stay in loop until conversion is done
L_LDR30:
        BTFSS      ADCON0+0, 2
        GOTO       L_LDR31
        GOTO       L_LDR30
L_LDR31:
;hbridgetest2.c,130 ::                 ADCON0 = ADCON0 & 0xFE;
        MOVLW      254
        ANDWF      ADCON0+0, 1
;hbridgetest2.c,132 ::                 res = (ADRESH << 8) | ADRESL; // save result
        MOVF       ADRESH+0, 0
        MOVWF      R0+1
        CLRF       R0+0
        MOVF       ADRESL+0, 0
        IORWF      R0+0, 1
        MOVLW      0
        IORWF      R0+1, 1
;hbridgetest2.c,134 ::                 return res;
;hbridgetest2.c,135 ::                 }
L_end_LDR:
        RETURN
; end of _LDR

_moist:

;hbridgetest2.c,137 ::                 unsigned int moist(){
;hbridgetest2.c,138 ::                 unsigned int res = 0;
;hbridgetest2.c,139 ::                 ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
        MOVLW      192
        MOVWF      ADCON1+0
;hbridgetest2.c,140 ::                 ADCON0 = 0x09; // A/D on, channel 1, go done is 0
        MOVLW      9
        MOVWF      ADCON0+0
;hbridgetest2.c,141 ::                 ADRESH = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESH+0
;hbridgetest2.c,142 ::                 ADRESL = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESL+0
;hbridgetest2.c,143 ::                 Delay_us(10);
        MOVLW      6
        MOVWF      R13+0
L_moist32:
        DECFSZ     R13+0, 1
        GOTO       L_moist32
        NOP
;hbridgetest2.c,144 ::                 ADCON0 = 0x0D; // A/D on, channel 1, go done is 1
        MOVLW      13
        MOVWF      ADCON0+0
;hbridgetest2.c,146 ::                 while(ADCON0 & 0x04); // stay in loop until conversion is done
L_moist33:
        BTFSS      ADCON0+0, 2
        GOTO       L_moist34
        GOTO       L_moist33
L_moist34:
;hbridgetest2.c,148 ::                 ADCON0 = ADCON0 & 0xF6;
        MOVLW      246
        ANDWF      ADCON0+0, 1
;hbridgetest2.c,150 ::                 res = (ADRESH << 8) | ADRESL; // save result
        MOVF       ADRESH+0, 0
        MOVWF      R0+1
        CLRF       R0+0
        MOVF       ADRESL+0, 0
        IORWF      R0+0, 1
        MOVLW      0
        IORWF      R0+1, 1
;hbridgetest2.c,152 ::                 return res;
;hbridgetest2.c,153 ::                 }
L_end_moist:
        RETURN
; end of _moist

_read_ph:

;hbridgetest2.c,155 ::                 unsigned int read_ph(){
;hbridgetest2.c,156 ::                 unsigned int res = 0;
;hbridgetest2.c,157 ::                 ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports are analog and refrence voltage is Vss --> Vdd
        MOVLW      192
        MOVWF      ADCON1+0
;hbridgetest2.c,158 ::                 ADCON0 = 0x11; //A/D on, channel 2, go done is 0
        MOVLW      17
        MOVWF      ADCON0+0
;hbridgetest2.c,159 ::                 ADRESH = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESH+0
;hbridgetest2.c,160 ::                 ADRESL = 0x00; // Clear Ananlog Result Values
        CLRF       ADRESL+0
;hbridgetest2.c,161 ::                 Delay_us(10);
        MOVLW      6
        MOVWF      R13+0
L_read_ph35:
        DECFSZ     R13+0, 1
        GOTO       L_read_ph35
        NOP
;hbridgetest2.c,162 ::                 ADCON0 = 0x15;
        MOVLW      21
        MOVWF      ADCON0+0
;hbridgetest2.c,164 ::                 while(ADCON0 & 0x04); // stay in loop until conversion is done
L_read_ph36:
        BTFSS      ADCON0+0, 2
        GOTO       L_read_ph37
        GOTO       L_read_ph36
L_read_ph37:
;hbridgetest2.c,166 ::                 ADCON0 = ADCON0 & 0xEE;
        MOVLW      238
        ANDWF      ADCON0+0, 1
;hbridgetest2.c,167 ::                 res = (ADRESH << 8) | ADRESL; // save result
        MOVF       ADRESH+0, 0
        MOVWF      R0+1
        CLRF       R0+0
        MOVF       ADRESL+0, 0
        IORWF      R0+0, 1
        MOVLW      0
        IORWF      R0+1, 1
;hbridgetest2.c,169 ::                 return res;
;hbridgetest2.c,170 ::                 }
L_end_read_ph:
        RETURN
; end of _read_ph

_calculate_ph:

;hbridgetest2.c,172 ::                 float calculate_ph(unsigned int adc_value) {
;hbridgetest2.c,174 ::                 float voltage = (adc_value * 5.1) / 1023.0;
        MOVF       FARG_calculate_ph_adc_value+0, 0
        MOVWF      R0+0
        MOVF       FARG_calculate_ph_adc_value+1, 0
        MOVWF      R0+1
        CALL       _word2double+0
        MOVLW      51
        MOVWF      R4+0
        MOVLW      51
        MOVWF      R4+1
        MOVLW      35
        MOVWF      R4+2
        MOVLW      129
        MOVWF      R4+3
        CALL       _Mul_32x32_FP+0
        MOVLW      0
        MOVWF      R4+0
        MOVLW      192
        MOVWF      R4+1
        MOVLW      127
        MOVWF      R4+2
        MOVLW      136
        MOVWF      R4+3
        CALL       _Div_32x32_FP+0
;hbridgetest2.c,177 ::                 float ph = (5.22 - voltage) / 0.153;
        MOVF       R0+0, 0
        MOVWF      R4+0
        MOVF       R0+1, 0
        MOVWF      R4+1
        MOVF       R0+2, 0
        MOVWF      R4+2
        MOVF       R0+3, 0
        MOVWF      R4+3
        MOVLW      61
        MOVWF      R0+0
        MOVLW      10
        MOVWF      R0+1
        MOVLW      39
        MOVWF      R0+2
        MOVLW      129
        MOVWF      R0+3
        CALL       _Sub_32x32_FP+0
        MOVLW      8
        MOVWF      R4+0
        MOVLW      172
        MOVWF      R4+1
        MOVLW      28
        MOVWF      R4+2
        MOVLW      124
        MOVWF      R4+3
        CALL       _Div_32x32_FP+0
;hbridgetest2.c,179 ::                 return ph;
;hbridgetest2.c,180 ::                 }
L_end_calculate_ph:
        RETURN
; end of _calculate_ph

_calculate_ph_v:

;hbridgetest2.c,182 ::                 float calculate_ph_v(unsigned int adc_value) {
;hbridgetest2.c,184 ::                 float voltage = (adc_value * 5.0) / 1023.0;
        MOVF       FARG_calculate_ph_v_adc_value+0, 0
        MOVWF      R0+0
        MOVF       FARG_calculate_ph_v_adc_value+1, 0
        MOVWF      R0+1
        CALL       _word2double+0
        MOVLW      0
        MOVWF      R4+0
        MOVLW      0
        MOVWF      R4+1
        MOVLW      32
        MOVWF      R4+2
        MOVLW      129
        MOVWF      R4+3
        CALL       _Mul_32x32_FP+0
        MOVLW      0
        MOVWF      R4+0
        MOVLW      192
        MOVWF      R4+1
        MOVLW      127
        MOVWF      R4+2
        MOVLW      136
        MOVWF      R4+3
        CALL       _Div_32x32_FP+0
;hbridgetest2.c,189 ::                 return voltage;
;hbridgetest2.c,190 ::                 }
L_end_calculate_ph_v:
        RETURN
; end of _calculate_ph_v

_read_lm35:

;hbridgetest2.c,192 ::                 unsigned int read_lm35() {
;hbridgetest2.c,193 ::                 unsigned int adc_value = 0;
;hbridgetest2.c,194 ::                 float voltage = 0.0;
;hbridgetest2.c,195 ::                 unsigned int temperature_C = 0;
;hbridgetest2.c,197 ::                 ADCON1 = 0xC0; // Right justification, conversion clock is fosc/4, all ports analog, Vref = Vdd
        MOVLW      192
        MOVWF      ADCON1+0
;hbridgetest2.c,198 ::                 ADCON0 = 0x19; // Select channel 3 (A3), A/D ON
        MOVLW      25
        MOVWF      ADCON0+0
;hbridgetest2.c,199 ::                 ADRESH = 0x00; // Clear previous result
        CLRF       ADRESH+0
;hbridgetest2.c,200 ::                 ADRESL = 0x00; // Clear previous result
        CLRF       ADRESL+0
;hbridgetest2.c,201 ::                 delay_us(10);   // Allow acquisition time
        MOVLW      6
        MOVWF      R13+0
L_read_lm3538:
        DECFSZ     R13+0, 1
        GOTO       L_read_lm3538
        NOP
;hbridgetest2.c,202 ::                 ADCON0 |= 0x04; // Start conversion
        BSF        ADCON0+0, 2
;hbridgetest2.c,204 ::                 while (ADCON0 & 0x04); // Wait for conversion to finish
L_read_lm3539:
        BTFSS      ADCON0+0, 2
        GOTO       L_read_lm3540
        GOTO       L_read_lm3539
L_read_lm3540:
;hbridgetest2.c,207 ::                 adc_value = (ADRESH << 8) | ADRESL;
        MOVF       ADRESH+0, 0
        MOVWF      R0+1
        CLRF       R0+0
        MOVF       ADRESL+0, 0
        IORWF      R0+0, 1
        MOVLW      0
        IORWF      R0+1, 1
;hbridgetest2.c,210 ::                 voltage = (adc_value * 5.0) / 1023.0;
        CALL       _word2double+0
        MOVLW      0
        MOVWF      R4+0
        MOVLW      0
        MOVWF      R4+1
        MOVLW      32
        MOVWF      R4+2
        MOVLW      129
        MOVWF      R4+3
        CALL       _Mul_32x32_FP+0
        MOVLW      0
        MOVWF      R4+0
        MOVLW      192
        MOVWF      R4+1
        MOVLW      127
        MOVWF      R4+2
        MOVLW      136
        MOVWF      R4+3
        CALL       _Div_32x32_FP+0
;hbridgetest2.c,213 ::                 temperature_C = voltage * 100;
        MOVLW      0
        MOVWF      R4+0
        MOVLW      0
        MOVWF      R4+1
        MOVLW      72
        MOVWF      R4+2
        MOVLW      133
        MOVWF      R4+3
        CALL       _Mul_32x32_FP+0
        CALL       _double2word+0
;hbridgetest2.c,215 ::                 return temperature_C;
;hbridgetest2.c,216 ::                 }
L_end_read_lm35:
        RETURN
; end of _read_lm35

_bluetooth_init:

;hbridgetest2.c,218 ::                 void bluetooth_init() {
;hbridgetest2.c,219 ::                 UART1_Init(9600);
        MOVLW      51
        MOVWF      SPBRG+0
        BSF        TXSTA+0, 2
        CALL       _UART1_Init+0
;hbridgetest2.c,220 ::                 our_delay_ms(100);   // Initialize UART with 9600 baud rate
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,221 ::                 }
L_end_bluetooth_init:
        RETURN
; end of _bluetooth_init

_pwm_init:

;hbridgetest2.c,223 ::                 void pwm_init() {
;hbridgetest2.c,225 ::                 CCP1CON = 0x0C; // Set CCP1M3 and CCP1M2 to 1, rest bits remain as they are
        MOVLW      12
        MOVWF      CCP1CON+0
;hbridgetest2.c,227 ::                 T2CON = T2CON | 0x07;// Set T2CKPS1, T2CKPS0, and TMR2ON to 1
        MOVLW      7
        IORWF      T2CON+0, 1
;hbridgetest2.c,229 ::                 PR2 = 249; // Set period register for 50Hz frequency
        MOVLW      249
        MOVWF      PR2+0
;hbridgetest2.c,230 ::                 }
L_end_pwm_init:
        RETURN
; end of _pwm_init

_set_servo_position1:

;hbridgetest2.c,232 ::                 void set_servo_position1(int degrees) {
;hbridgetest2.c,233 ::                 int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
        MOVLW      90
        ADDWF      FARG_set_servo_position1_degrees+0, 0
        MOVWF      R3+0
        MOVF       FARG_set_servo_position1_degrees+1, 0
        BTFSC      STATUS+0, 0
        ADDLW      1
        MOVWF      R3+1
        MOVLW      3
        MOVWF      R2+0
        MOVF       R3+0, 0
        MOVWF      R0+0
        MOVF       R3+1, 0
        MOVWF      R0+1
        MOVF       R2+0, 0
L__set_servo_position186:
        BTFSC      STATUS+0, 2
        GOTO       L__set_servo_position187
        RLF        R0+0, 1
        RLF        R0+1, 1
        BCF        R0+0, 0
        ADDLW      255
        GOTO       L__set_servo_position186
L__set_servo_position187:
        MOVLW      244
        ADDWF      R0+0, 0
        MOVWF      R3+0
        MOVF       R0+1, 0
        BTFSC      STATUS+0, 0
        ADDLW      1
        ADDLW      1
        MOVWF      R3+1
;hbridgetest2.c,234 ::                 CCPR1L = pulse_width >> 2; // Set CCPR1L register
        MOVF       R3+0, 0
        MOVWF      R0+0
        MOVF       R3+1, 0
        MOVWF      R0+1
        RRF        R0+1, 1
        RRF        R0+0, 1
        BCF        R0+1, 7
        BTFSC      R0+1, 6
        BSF        R0+1, 7
        RRF        R0+1, 1
        RRF        R0+0, 1
        BCF        R0+1, 7
        BTFSC      R0+1, 6
        BSF        R0+1, 7
        MOVF       R0+0, 0
        MOVWF      CCPR1L+0
;hbridgetest2.c,235 ::                 CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
        MOVLW      207
        ANDWF      CCP1CON+0, 0
        MOVWF      R5+0
        MOVLW      3
        ANDWF      R3+0, 0
        MOVWF      R2+0
        MOVF       R2+0, 0
        MOVWF      R0+0
        RLF        R0+0, 1
        BCF        R0+0, 0
        RLF        R0+0, 1
        BCF        R0+0, 0
        RLF        R0+0, 1
        BCF        R0+0, 0
        RLF        R0+0, 1
        BCF        R0+0, 0
        MOVF       R0+0, 0
        IORWF      R5+0, 0
        MOVWF      CCP1CON+0
;hbridgetest2.c,236 ::                 our_delay_ms(50*4); // Delay for the servo to reach the desired position
        MOVLW      200
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,237 ::                 PORTD = 0x00;
        CLRF       PORTD+0
;hbridgetest2.c,238 ::                 }
L_end_set_servo_position1:
        RETURN
; end of _set_servo_position1

_send_sensor_data:

;hbridgetest2.c,240 ::                 void send_sensor_data(unsigned int distance, unsigned int ldr_value, unsigned int moist_value, unsigned int temperature) {
;hbridgetest2.c,245 ::                 IntToStr(distance, buffer);   // Convert integer to string
        MOVF       FARG_send_sensor_data_distance+0, 0
        MOVWF      FARG_IntToStr_input+0
        MOVF       FARG_send_sensor_data_distance+1, 0
        MOVWF      FARG_IntToStr_input+1
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_IntToStr_output+0
        CALL       _IntToStr+0
;hbridgetest2.c,246 ::                 UART1_Write_Text(buffer);
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,247 ::                 UART1_Write_Text(",");
        MOVLW      ?lstr1_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,251 ::                 IntToStr(ldr_value, buffer); // Convert integer to string
        MOVF       FARG_send_sensor_data_ldr_value+0, 0
        MOVWF      FARG_IntToStr_input+0
        MOVF       FARG_send_sensor_data_ldr_value+1, 0
        MOVWF      FARG_IntToStr_input+1
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_IntToStr_output+0
        CALL       _IntToStr+0
;hbridgetest2.c,252 ::                 UART1_Write_Text(buffer);
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,253 ::                 UART1_Write_Text(",");
        MOVLW      ?lstr2_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,257 ::                 IntToStr(moist_value, buffer); // Convert integer to string
        MOVF       FARG_send_sensor_data_moist_value+0, 0
        MOVWF      FARG_IntToStr_input+0
        MOVF       FARG_send_sensor_data_moist_value+1, 0
        MOVWF      FARG_IntToStr_input+1
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_IntToStr_output+0
        CALL       _IntToStr+0
;hbridgetest2.c,258 ::                 UART1_Write_Text(buffer);
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,259 ::                 UART1_Write_Text(",");
        MOVLW      ?lstr3_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,261 ::                 IntToStr(temperature, buffer);
        MOVF       FARG_send_sensor_data_temperature+0, 0
        MOVWF      FARG_IntToStr_input+0
        MOVF       FARG_send_sensor_data_temperature+1, 0
        MOVWF      FARG_IntToStr_input+1
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_IntToStr_output+0
        CALL       _IntToStr+0
;hbridgetest2.c,262 ::                 UART1_Write_Text(buffer);
        MOVLW      send_sensor_data_buffer_L0+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,263 ::                 UART1_Write_Text(",");
        MOVLW      ?lstr4_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,265 ::                 our_delay_ms(200);
        MOVLW      200
        MOVWF      FARG_our_delay_ms_ms+0
        CLRF       FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,267 ::                 }
L_end_send_sensor_data:
        RETURN
; end of _send_sensor_data

_send_PH_data:

;hbridgetest2.c,269 ::                 void send_PH_data(unsigned int ph){
;hbridgetest2.c,271 ::                 FloatToStr(ph, buffer);   // Convert integer to string
        MOVF       FARG_send_PH_data_ph+0, 0
        MOVWF      R0+0
        MOVF       FARG_send_PH_data_ph+1, 0
        MOVWF      R0+1
        CALL       _word2double+0
        MOVF       R0+0, 0
        MOVWF      FARG_FloatToStr_fnum+0
        MOVF       R0+1, 0
        MOVWF      FARG_FloatToStr_fnum+1
        MOVF       R0+2, 0
        MOVWF      FARG_FloatToStr_fnum+2
        MOVF       R0+3, 0
        MOVWF      FARG_FloatToStr_fnum+3
        MOVLW      send_PH_data_buffer_L0+0
        MOVWF      FARG_FloatToStr_str+0
        CALL       _FloatToStr+0
;hbridgetest2.c,272 ::                 UART1_Write_Text(buffer);
        MOVLW      send_PH_data_buffer_L0+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,273 ::                 }
L_end_send_PH_data:
        RETURN
; end of _send_PH_data

_forward:

;hbridgetest2.c,275 ::                 void forward(){
;hbridgetest2.c,276 ::                 PORTD = 0x91;
        MOVLW      145
        MOVWF      PORTD+0
;hbridgetest2.c,277 ::                 our_delay_ms(100);
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,278 ::                 }
L_end_forward:
        RETURN
; end of _forward

_backward:

;hbridgetest2.c,280 ::                 void backward(){
;hbridgetest2.c,281 ::                 PORTD = 0x62;
        MOVLW      98
        MOVWF      PORTD+0
;hbridgetest2.c,282 ::                 our_delay_ms(100);
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,283 ::                 }
L_end_backward:
        RETURN
; end of _backward

_left:

;hbridgetest2.c,285 ::                 void left(){
;hbridgetest2.c,286 ::                 PORTD = 0xA4;
        MOVLW      164
        MOVWF      PORTD+0
;hbridgetest2.c,287 ::                 our_delay_ms(100);
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,288 ::                 }
L_end_left:
        RETURN
; end of _left

_right:

;hbridgetest2.c,290 ::                 void right(){
;hbridgetest2.c,291 ::                 PORTD = 0x58;
        MOVLW      88
        MOVWF      PORTD+0
;hbridgetest2.c,292 ::                 our_delay_ms(100);
        MOVLW      100
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      0
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,293 ::                 }
L_end_right:
        RETURN
; end of _right

_stop:

;hbridgetest2.c,295 ::                 void stop(){
;hbridgetest2.c,296 ::                 PORTD = 0x00;
        CLRF       PORTD+0
;hbridgetest2.c,297 ::                 our_delay_ms(200);
        MOVLW      200
        MOVWF      FARG_our_delay_ms_ms+0
        CLRF       FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,298 ::                 }
L_end_stop:
        RETURN
; end of _stop

_led_on:

;hbridgetest2.c,300 ::                 void led_on(){
;hbridgetest2.c,301 ::                 PORTD = 0x0F;
        MOVLW      15
        MOVWF      PORTD+0
;hbridgetest2.c,302 ::                 our_delay_ms(300);
        MOVLW      44
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      1
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,303 ::                 }
L_end_led_on:
        RETURN
; end of _led_on

_led_mid_on:

;hbridgetest2.c,305 ::                 void led_mid_on(){
;hbridgetest2.c,306 ::                 PORTD = 0x06;
        MOVLW      6
        MOVWF      PORTD+0
;hbridgetest2.c,307 ::                 our_delay_ms(300);
        MOVLW      44
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      1
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,308 ::                 }
L_end_led_mid_on:
        RETURN
; end of _led_mid_on

_led_outer_on:

;hbridgetest2.c,310 ::                 void led_outer_on(){
;hbridgetest2.c,311 ::                 PORTD = 0x09;
        MOVLW      9
        MOVWF      PORTD+0
;hbridgetest2.c,312 ::                 our_delay_ms(300);
        MOVLW      44
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      1
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,313 ::                 }
L_end_led_outer_on:
        RETURN
; end of _led_outer_on

_main:

;hbridgetest2.c,315 ::                 void main() {
;hbridgetest2.c,326 ::                 setup();
        CALL       _setup+0
;hbridgetest2.c,327 ::                 bluetooth_init();
        CALL       _bluetooth_init+0
;hbridgetest2.c,328 ::                 pwm_init();
        CALL       _pwm_init+0
;hbridgetest2.c,329 ::                 UART1_Write_Text("System Start\r\n"); // Send a startup message
        MOVLW      ?lstr5_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,331 ::                 while(1){
L_main41:
;hbridgetest2.c,332 ::                 distance = measure_distance();
        CALL       _measure_distance+0
        MOVF       R0+0, 0
        MOVWF      main_distance_L0+0
        MOVF       R0+1, 0
        MOVWF      main_distance_L0+1
;hbridgetest2.c,333 ::                 ldr_value = LDR();
        CALL       _LDR+0
        MOVF       R0+0, 0
        MOVWF      main_ldr_value_L0+0
        MOVF       R0+1, 0
        MOVWF      main_ldr_value_L0+1
;hbridgetest2.c,334 ::                 moist_value = moist();
        CALL       _moist+0
        MOVF       R0+0, 0
        MOVWF      main_moist_value_L0+0
        MOVF       R0+1, 0
        MOVWF      main_moist_value_L0+1
;hbridgetest2.c,335 ::                 temperature = read_lm35(); // Read temperature from LM35
        CALL       _read_lm35+0
        MOVF       R0+0, 0
        MOVWF      main_temperature_L0+0
        MOVF       R0+1, 0
        MOVWF      main_temperature_L0+1
;hbridgetest2.c,336 ::                 ph_adc_value = read_ph();  // Read the analog value from the sensor
        CALL       _read_ph+0
;hbridgetest2.c,337 ::                 ph = calculate_ph(ph_adc_value);  // Convert ADC value to pH
        MOVF       R0+0, 0
        MOVWF      FARG_calculate_ph_adc_value+0
        MOVF       R0+1, 0
        MOVWF      FARG_calculate_ph_adc_value+1
        CALL       _calculate_ph+0
        MOVF       R0+0, 0
        MOVWF      main_ph_L0+0
        MOVF       R0+1, 0
        MOVWF      main_ph_L0+1
        MOVF       R0+2, 0
        MOVWF      main_ph_L0+2
        MOVF       R0+3, 0
        MOVWF      main_ph_L0+3
;hbridgetest2.c,340 ::                 StartSignal();
        CALL       _StartSignal+0
;hbridgetest2.c,341 ::                 CheckResponse();
        CALL       _CheckResponse+0
;hbridgetest2.c,343 ::                 if (UART1_Data_Ready()) {
        CALL       _UART1_Data_Ready+0
        MOVF       R0+0, 0
        BTFSC      STATUS+0, 2
        GOTO       L_main43
;hbridgetest2.c,345 ::                 received_data = UART1_Read();  // Read the received data
        CALL       _UART1_Read+0
        MOVF       R0+0, 0
        MOVWF      main_received_data_L0+0
;hbridgetest2.c,348 ::                 if(received_data == 'F'){
        MOVF       R0+0, 0
        XORLW      70
        BTFSS      STATUS+0, 2
        GOTO       L_main44
;hbridgetest2.c,349 ::                 forward();
        CALL       _forward+0
;hbridgetest2.c,350 ::                 } else if(received_data == 'B'){
        GOTO       L_main45
L_main44:
        MOVF       main_received_data_L0+0, 0
        XORLW      66
        BTFSS      STATUS+0, 2
        GOTO       L_main46
;hbridgetest2.c,351 ::                 backward();
        CALL       _backward+0
;hbridgetest2.c,352 ::                 } else if (received_data == 'D'){
        GOTO       L_main47
L_main46:
        MOVF       main_received_data_L0+0, 0
        XORLW      68
        BTFSS      STATUS+0, 2
        GOTO       L_main48
;hbridgetest2.c,353 ::                 send_sensor_data(distance, ldr_value, moist_value, temperature);
        MOVF       main_distance_L0+0, 0
        MOVWF      FARG_send_sensor_data_distance+0
        MOVF       main_distance_L0+1, 0
        MOVWF      FARG_send_sensor_data_distance+1
        MOVF       main_ldr_value_L0+0, 0
        MOVWF      FARG_send_sensor_data_ldr_value+0
        MOVF       main_ldr_value_L0+1, 0
        MOVWF      FARG_send_sensor_data_ldr_value+1
        MOVF       main_moist_value_L0+0, 0
        MOVWF      FARG_send_sensor_data_moist_value+0
        MOVF       main_moist_value_L0+1, 0
        MOVWF      FARG_send_sensor_data_moist_value+1
        MOVF       main_temperature_L0+0, 0
        MOVWF      FARG_send_sensor_data_temperature+0
        MOVF       main_temperature_L0+1, 0
        MOVWF      FARG_send_sensor_data_temperature+1
        CALL       _send_sensor_data+0
;hbridgetest2.c,354 ::                 send_PH_data(ph);
        MOVF       main_ph_L0+0, 0
        MOVWF      R0+0
        MOVF       main_ph_L0+1, 0
        MOVWF      R0+1
        MOVF       main_ph_L0+2, 0
        MOVWF      R0+2
        MOVF       main_ph_L0+3, 0
        MOVWF      R0+3
        CALL       _double2word+0
        MOVF       R0+0, 0
        MOVWF      FARG_send_PH_data_ph+0
        MOVF       R0+1, 0
        MOVWF      FARG_send_PH_data_ph+1
        CALL       _send_PH_data+0
;hbridgetest2.c,355 ::                 UART1_Write_Text("\r\n\n");
        MOVLW      ?lstr6_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,356 ::                 our_delay_ms(200) ;
        MOVLW      200
        MOVWF      FARG_our_delay_ms_ms+0
        CLRF       FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,357 ::                 } else if (received_data == 'W'){
        GOTO       L_main49
L_main48:
        MOVF       main_received_data_L0+0, 0
        XORLW      87
        BTFSS      STATUS+0, 2
        GOTO       L_main50
;hbridgetest2.c,358 ::                 UART1_Write_Text("\nDistance, LDR, Moist, Temp, PH");
        MOVLW      ?lstr7_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,359 ::                 UART1_Write_Text("\r\n\n");
        MOVLW      ?lstr8_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,360 ::                 } else if (received_data == 'S'){
        GOTO       L_main51
L_main50:
        MOVF       main_received_data_L0+0, 0
        XORLW      83
        BTFSS      STATUS+0, 2
        GOTO       L_main52
;hbridgetest2.c,361 ::                 set_servo_position1(90);
        MOVLW      90
        MOVWF      FARG_set_servo_position1_degrees+0
        MOVLW      0
        MOVWF      FARG_set_servo_position1_degrees+1
        CALL       _set_servo_position1+0
;hbridgetest2.c,362 ::                 our_delay_ms(500);
        MOVLW      244
        MOVWF      FARG_our_delay_ms_ms+0
        MOVLW      1
        MOVWF      FARG_our_delay_ms_ms+1
        CALL       _our_delay_ms+0
;hbridgetest2.c,363 ::                 set_servo_position1(-90);
        MOVLW      166
        MOVWF      FARG_set_servo_position1_degrees+0
        MOVLW      255
        MOVWF      FARG_set_servo_position1_degrees+1
        CALL       _set_servo_position1+0
;hbridgetest2.c,364 ::                 set_servo_position1(0);
        CLRF       FARG_set_servo_position1_degrees+0
        CLRF       FARG_set_servo_position1_degrees+1
        CALL       _set_servo_position1+0
;hbridgetest2.c,365 ::                 } else if (received_data == 'L'){
        GOTO       L_main53
L_main52:
        MOVF       main_received_data_L0+0, 0
        XORLW      76
        BTFSS      STATUS+0, 2
        GOTO       L_main54
;hbridgetest2.c,366 ::                 right();
        CALL       _right+0
;hbridgetest2.c,367 ::                 } else if (received_data == 'R'){
        GOTO       L_main55
L_main54:
        MOVF       main_received_data_L0+0, 0
        XORLW      82
        BTFSS      STATUS+0, 2
        GOTO       L_main56
;hbridgetest2.c,368 ::                 left();
        CALL       _left+0
;hbridgetest2.c,369 ::                 } else if (received_data == 'O'){
        GOTO       L_main57
L_main56:
        MOVF       main_received_data_L0+0, 0
        XORLW      79
        BTFSS      STATUS+0, 2
        GOTO       L_main58
;hbridgetest2.c,370 ::                 led_on();
        CALL       _led_on+0
;hbridgetest2.c,371 ::                 } else if (received_data == 'X'){
        GOTO       L_main59
L_main58:
        MOVF       main_received_data_L0+0, 0
        XORLW      88
        BTFSS      STATUS+0, 2
        GOTO       L_main60
;hbridgetest2.c,372 ::                 led_on();
        CALL       _led_on+0
;hbridgetest2.c,373 ::                 stop();
        CALL       _stop+0
;hbridgetest2.c,374 ::                 } else {
        GOTO       L_main61
L_main60:
;hbridgetest2.c,375 ::                 UART1_Write_Text("\nI hate my life\r\n\n");
        MOVLW      ?lstr9_hbridgetest2+0
        MOVWF      FARG_UART1_Write_Text_uart_text+0
        CALL       _UART1_Write_Text+0
;hbridgetest2.c,376 ::                 }
L_main61:
L_main59:
L_main57:
L_main55:
L_main53:
L_main51:
L_main49:
L_main47:
L_main45:
;hbridgetest2.c,377 ::                 }
L_main43:
;hbridgetest2.c,399 ::                 }
        GOTO       L_main41
;hbridgetest2.c,400 ::                 }
L_end_main:
        GOTO       $+0
; end of _main