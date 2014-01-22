#!/usr/bin/python

########### The following is included in therm_log.py, but may be useful elsewhere

import RPi.GPIO as GPIO
from time import sleep

# Use Broadcom chip reference for GPIO
#GPIO.setmode(GPIO.BCM)

# Suppress channel already in use warning
#GPIO.setwarnings(False)

# name pins

#pin1 = 4
#pin2 = 21
#pin3 = 17

# Setup outputs
#GPIO.setup(pin1, GPIO.OUT)
#GPIO.setup(pin2, GPIO.OUT)
#GPIO.setup(pin3, GPIO.OUT)

# Set default state of outputs to low
#GPIO.output(pin3, False) # Can also take True of False

#############################

count = 0

def LEDinit(pin):

	n1 = 0.5
	n2 = 0.3
	n3 = 1

	count = 0 

	while count < 3:
		GPIO.output(pin, GPIO.HIGH)
		sleep(n1)
		GPIO.output(pin, GPIO.LOW)
		sleep(n1)
		count += 1

#	count = 0
#
#	while count < 4:
#		GPIO.output(pin, GPIO.HIGH)
#		sleep(n2)
#		GPIO.output(pin, GPIO.LOW)
#		sleep(n2)
#		count += 1

	else:
		GPIO.output(pin,GPIO.HIGH)	
		sleep(n3)
		GPIO.output(pin, GPIO.LOW)

#LEDinit(pin3)
