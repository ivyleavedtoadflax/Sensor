# Sensor

Code for running a raspberry pi powered sensor platform for monitoring internal and external temperature, light, and humidity.

Latest branch is SensorPiB - will get round to cleaning up the other branches one day.

System currently consists of two DS18b20 onewire temperature sensors, one DHT22 temperature and humidity sensor, and a light dependent resistor (LDR) hooked up to a capacitor to provide a digital output for sensing light.

Programming for the pis is all in python, graphing is all in R. Currently using deprecated Adafruit python driver for DHT22 but will update in futute to [https://github.com/adafruit/Adafruit_Python_DHT]([https://github.com/adafruit/Adafruit_Python_DHT]).
