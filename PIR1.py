##!/usr/bin/python

########### 

import RPi.GPIO as GPIO
from time import sleep

# Use Broadcom chip reference for GPIO
GPIO.setmode(GPIO.BCM)

# Suppress channel already in use warning
GPIO.setwarnings(False)

# name pins

pin5 = 17 

# Setup outputs
GPIO.setup(pin5, GPIO.IN)

count = 0

while True: 
	if (GPIO.input(pin5) == GPIO.HIGH):
#		log = open("/home/pi/therm/PIRState", "a")
#		log.write("1")
#		log.close()
		count +=1
		print(count)
		sleep(1)
	else:
#		log = open("/home/pi/therm/PIRState", "a")
#		log.write("0")
#		log.close()
		print("0")
		count = 0
		sleep(1)
