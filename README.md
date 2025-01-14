# IoT Enabled Agricultural Car
Welcome to the IoT Enabled Agricultural Car page. This repository houses the source code and documentation for our system. The car is owered by the PIC16F877A microcontroller. What sets our system apart is the fact that it is IoT-enabled, this allows users to monitor and control the system without being physically there. This is achieved by the smart use of Python scripts that let the host PC act as a middle node. The PIC16F877A collects data from sensors, then that data is sent to the PC via bluetooth. That data is then sent to an online platform to be displayed on a dashboard. This will help farmers track the environment of their land remotely, this is extremely useful for them and would save them alot of time and money. The repository includes the PIC16F877A source code, hardware specifications, and documentation. 


# Table of Contents
- <span style="color:blue">[Requirements](#requirements)</span>
- <span style="color:blue">[Hardware Setup](#hardware-setup)</span>
- <span style="color:blue">[Software Setup](#software-setup)</span>
- <span style="color:blue">[Other](#other)</span>

# Requirements
- PIC16F877A microcontroller
- Ultrasonic Distance Sensor
- PH Sensor
- Soil Moisture Sensor
- Temperature Sensor
- LEDs
- 4 DC Motors
- Servo Motor
- Motor Driver(H-Bridge)
- Bluetooth HC-06
- CRYSTAL Oscillator (8 MHz)
- 12V Battery
- 5V Battery

# Hardware Setup
![Hardware Setup](Pictures/Schematic.jpg)
