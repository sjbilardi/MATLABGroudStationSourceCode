# MATLAB Groud Station Source Code

Receives data from BoSS programmed system to plot telemetry in MATLAB GUI. Receives the following over serial connection from ATmega644PA microcontroller:

- Temperature from thermistor 1
- Temperature from thermistor 2
- Battery voltage
- Battery current draw
- Sun angle (current orientation of solar tracker)

To use, download the "mctrst.m" and "mctrst.fig" files from the "CodeFiles" folder and run "mctrst.m" in MATLAB. Received data will be saved as "CSV" files in the folder from where the MATLAB files is located.

**NOTE:** The "CSV" file for a one hour test is in the "OneHourSystemTestData" folder 
