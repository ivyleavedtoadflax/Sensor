#!/usr/bin/python

import RPi.GPIO as GPIO
from time import sleep
from time import strftime
from subprocess import call
from subprocess import check_output
#from checkGmail import check
#from re import search
import string, os
import Adafruit_DHT
#import smtplib, string, os

#	(ORANGE) 3.3v	[][]	5v (RED)
#	I2C0 SDA	[][]	DO NOT CONNECT
#	I2C0 SCL	[][]	GROUND (BLACK)
#	(GREEN) GPIO 4	[][]	UART TXD
#	DO NOT CONNECT	[][]	UART RXD
#	(YELLOW) GPIO 17[][]	GPIO 18 (ORANGE)
#	(BLUE) GPIO 21	[][]	DO NOT CONNECT
#	(PURPLE) GPIO 22[][]	GPIO 23
#	DO NOT CONNECT	[][]	GPIO 24
#	SPI MOSI	[][]	DO NOT CONNECT
#	SPI MISO	[][]	GPIO 25
#	SPI SCLK	[][]	SP10 CEO N
#	DO NOT CONNECT	[][]	SP10 CE1 N


# Use Broadcom chip reference for GPIO
GPIO.setmode(GPIO.BCM)

# Suppress "channel already in use" warning
GPIO.setwarnings(False)

# name pins

pin1 = 4 	# Temperature sensor	# GREEN
pin2 = 17	# LED 1					# YELLOW
pin4 = 18	# Photoresistor			# ORANGE
# pin5 = 21	# PIR					

# Setup outputs
GPIO.setup(pin1, GPIO.OUT)
GPIO.setup(pin2, GPIO.OUT)
GPIO.setup(pin4, GPIO.OUT)
# GPIO.setup(pin5, GPIO.IN)

def readSensor(w1):
#	global temperature
	tfile = open("/sys/bus/w1/devices/" + w1 + "/w1_slave","r") # Open te$
        text = tfile.read() # Read all of the text in the file.
        tfile.close() # Close the file now that the text has been read.
        secondline = text.split("\n")[1] # Split the text with new lines (\n) and $
        temperaturedata = secondline.split(" ")[9] # Split the line into words, re$
        temp = float(temperaturedata[2:]) # The first two characters are "t$
        temperature = temp / 1000 # Put the decimal point in the right plac$
	return temperature	


# set initial pin states
GPIO.output(pin2, GPIO.LOW)
GPIO.output(pin4, GPIO.LOW) 
	
	# Run data recording LED init sequence
	
ledCount = 0
while ledCount <3:
	GPIO.output(pin2, GPIO.HIGH)
	sleep(0.2)
	GPIO.output(pin2, GPIO.LOW)
	sleep(0.2)
	ledCount +=1

# Get reading from temperature sensor

temperature = "NA"
temperature1 = "NA"

try:
	temperature = readSensor('28-000004021a46')
except:
	pass

try:
	temperature1 = readSensor('28-000004024b05')
except:
	pass
	
# Get data from DHT22 humidity and temp sensor

humidity = "NA"
temperature2 = "NA"	

humidity, temperature2 = Adafruit_DHT.read_retry(Adafruit_DHT.DHT22, 23)
	
humidity = ("%.2f" % humidity)
temperature2 = ("%.3f" % temperature2)


print temperature2
	# Get reading from photoreceptor

light = 0
	
GPIO.setup(pin4, GPIO.IN)		 # This takes about 1 millisecond per loop cycle
while (GPIO.input(pin4) == GPIO.LOW):
	light += 1
GPIO.setup(pin4, GPIO.OUT)

timestamp = strftime("%Y-%m-%d,%H:%M:%S")
	
# log data in text file
	
log = open("Log.csv", "a")
log.write("\n" + str(timestamp) + "," + str(temperature) + "," + str(temperature1) + "," + str(temperature2) + "," + str(light) + "," + str(humidity))
log.close()

# Reset PIRState

#	PIRState = open("/home/pi/Sensor/PIRState", "w")
#	PIRState.write("0")
#	PIRState.close()

	# Check for log frequency

freq = open("logFreq","r")
logFreq = int(freq.read()) # check file for log frequency (in seconds)
freq.close()
	
		# Run R command to create plots
	
try :
	counter = open("counter","r")
	counterInt = int(counter.read())
	counter.close()
	#matches = search("0-20", counterInt)
	counter = open("counter","w")
		
		#if (not matches) or (counterInt == 20):
	if (counterInt == 10):
		counter.write("0")
		call('sudo Rscript daily_plot1.R',shell=True)
		# RPlotLog = open("/home/pi/Sensor/RPlotLog.csv", "a")
		# RPlotLog.write(timestamp + "\n")
		# RPlotLog.close()
 
	if (counterInt < 10):
		counter.write(str(counterInt+1))
	
	counter.close()
		
except:
	pass
	

#	sleep(logFreq) # cancel this if running by crontab	

