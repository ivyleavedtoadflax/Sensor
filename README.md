# Sensor

Code for running a raspberry pi powered sensor platform for monitoring internal and external temperature, light, and humidity.

Latest branch is SensorPiB - will get round to cleaning up the other branches one day.

System currently consists of two DS18b20 onewire temperature sensors, one DHT22 temperature and humidity sensor, and a light dependent resistor (LDR) hooked up to a capacitor to provide a digital output for sensing light. Also added is an Adafruit ultimate GPS module, partly just for practice, and partly because I had a crazy notion of running the whole thing in my car...or something.

Programming for the pis is all in python, graphing is all in R. Currently using Adafruit python driver for DHT22 [https://github.com/adafruit/Adafruit_Python_DHT]([https://github.com/adafruit/Adafruit_Python_DHT]).
