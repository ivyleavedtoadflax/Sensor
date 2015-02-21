#!/usr/bin/python

import RPi.GPIO as GPIO
from time import sleep
from time import strftime

############### MAP OF GPIO PINS ################
#						#
#	(ORANGE) 3.3v	[][]  5v (RED)		#
#	I2C0 SDA	[][]  DO NOT CONNECT	#
#	I2C0 SCL	[][]  GROUND (BLACK)	#
#	(GREEN) GPIO 4	[][]  UART TXD		#
#	DO NOT CONNECT	[][]  UART RXD		#
#	(YELLOW) GPIO 17[][]  GPIO 18 (ORANGE)	#
#	(BLUE) GPIO 21	[][]  DO NOT CONNECT	#
#	(PURPLE) GPIO 22[][]  GPIO 23		#
#	DO NOT CONNECT	[][]  GPIO 24		#
#	SPI MOSI	[][]  DO NOT CONNECT	#
#	SPI MISO	[][]  GPIO 25		#
#	SPI SCLK	[][]  SP10 CEO N	#
#	DO NOT CONNECT	[][]  SP10 CE1 N	#
#						#
#################################################

######################### Setup GPIO PINS #########################

# Use Broadcom chip reference for GPIO
GPIO.setmode(GPIO.BCM)

# Suppress "channel already in use" warning
GPIO.setwarnings(False)

# name pins

pin1 = 4        # Temperature sensor

# Setup outputs
GPIO.setup(pin1, GPIO.OUT)
# GPIO.setup(pin5, GPIO.IN)

# Set all variables to NA

timestamp = "NA"
temperature = "NA"

# Define functions

# This code is adapted from here: https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/temperature/

def readTemp(w1):
	try:
		tfile = open("/sys/bus/w1/devices/" + w1 + "/w1_slave","r") # Open te$
        	text = tfile.read() # Read all of the text in the file.
        	tfile.close() # Close the file now that the text has been read.
        	secondline = text.split("\n")[1] # Split the text with new lines (\n) and $
        	temperaturedata = secondline.split(" ")[9] # Split the line into words, re$
        	temp = float(temperaturedata[2:]) # The first two characters are "t$
        	temperature = temp / 1000 # Put the decimal point in the right plac$
		return temperature
	except:
		pass

def write_log_csv(ts,temp):
        log = open("/home/pi/Sensor/Log.csv", "a")
	log.write("\n" + str(ts) + "," + str(temp))
	log.close()

def main():

	timestamp = strftime("%Y-%m-%d %H:%M:00")
	temperature = readTemp('28-00000697c53e')
        write_log_csv(timestamp,temperature)

if __name__ == '__main__':
	main()
