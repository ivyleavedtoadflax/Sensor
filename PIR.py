##!/usr/bin/python

########### 

import RPi.GPIO as GPIO
from time import sleep
from time import strftime
from LEDinit import LEDinit

# Use Broadcom chip reference for GPIO
GPIO.setmode(GPIO.BCM)

# Suppress channel already in use warning
GPIO.setwarnings(False)

# name pins

pin5 = 21

# Setup outputs
GPIO.setup(pin5, GPIO.IN)

count = 0
count1 = 0

print("Initialising PIR")

print("45 seconds...")
sleep(25)
print("20 seconds...")
sleep(20)

print("5 seconds...")
print("PIR initialised")


while True: 
	if (GPIO.input(pin5) == GPIO.HIGH):
		if count1 > 0:
			timestamp = strftime("%Y-%m-%d,%H:%M:%S")
			PIRlog = open("/home/pi/Sensor/PIRLog.csv", "a")
			PIRlog.write("\n" + timestamp + "," + "LOW" + "," + str(count1))
			PIRlog.close()
		count1 = 0
		PIRState = open("/home/pi/Sensor/PIRState", "w")
		PIRState.write("1")
		PIRState.close()
		count += 0.1
		sleep(0.1)	
	else:
		if count > 0:
			timestamp = strftime("%Y-%m-%d,%H:%M:%S")
			PIRlog = open("/home/pi/Sensor/PIRLog.csv", "a")
			PIRlog.write("\n" + timestamp + "," + "HIGH" + "," + str(count))
			PIRlog.close()
		count = 0
		#PIRState = open("/home/pi/Sensor/PIRState", "w")
		#PIRState.write("0")
		#PIRState.close()
		count1 += 0.1
		sleep(0.1)
		
