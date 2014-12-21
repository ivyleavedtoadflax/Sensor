#!/usr/bin/python

import RPi.GPIO as GPIO
from time import sleep
from time import strftime
import string, os, sys
import Adafruit_DHT
import sqlite3


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

######################### Setup GPIO PINS #########################

# Use Broadcom chip reference for GPIO
GPIO.setmode(GPIO.BCM)

# Suppress "channel already in use" warning
GPIO.setwarnings(False)

# name pins

pin1 = 4        # Temperature sensor
pin2 = 17       # LED
pin4 = 18       # Photoresistor 

# pin 23 = DHT          

# Setup outputs
GPIO.setup(pin1, GPIO.OUT)
GPIO.setup(pin2, GPIO.OUT)
GPIO.setup(pin4, GPIO.OUT)
# GPIO.setup(pin5, GPIO.IN)

# set initial pin states
GPIO.output(pin2, GPIO.HIGH)
GPIO.output(pin4, GPIO.LOW)

# Set all variables to NA

timestamp = "NA"
temperature = "NA"
temperature1 = "NA"
temperature2 = "NA"
light = 0 # must be numeric
humidity = "NA"

# Define functions

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

# Run data recording LED init sequence
	
ledCount = 0
while ledCount <3:
	GPIO.output(pin2, GPIO.LOW)
	sleep(0.2)
	GPIO.output(pin2, GPIO.HIGH)
	sleep(0.2)
	ledCount +=1

# log data in text file
def write_log_csv():
        log = open("/home/pi/Sensor/Log.csv", "a")
	log.write("\n" + str(timestamp) + "," + str(temperature) + "," + str(temperature1) + "," + str(temperature2) + "," + str(light) + "," + str(humidity))
	log.close()

# Log into /www/var/Log.db - sqlite3 database

def write_log_sql():
        conn = sqlite3.connect("/var/www/SensorPiB.db")
        curs = conn.cursor()
	curs.execute("INSERT INTO SensorPiB values('" + str(timestamp) + "','" + str(temperature) + "','" + str(temperature1) + "','" + str(temperature2) + "','" + str(light) + "','" +  str(humidity) + "')")
        conn.commit()
        conn.close()

# Get reading from ds18b20 sensors

try:
	temperature = readSensor('28-000004021a46')
except:
	pass

try:
	temperature1 = readSensor('28-000004024b05')
except:
	pass
	
# Get data from DHT22 humidity and temp sensor

try:
	humidity, temperature2 = Adafruit_DHT.read_retry(Adafruit_DHT.DHT22, 23)
	humidity = ("%.2f" % humidity)
	temperature2 = ("%.3f" % temperature2)
except:
	pass

# Get reading from photoreceptor

GPIO.setup(pin4, GPIO.IN)		 # This takes about 1 millisecond per loop cycle
while (GPIO.input(pin4) == GPIO.LOW):
	light += 1
GPIO.setup(pin4, GPIO.OUT)

timestamp = strftime("%Y-%m-%d %H:%M:00")
#timestamp = strftime("%Y-%m-%d %H:%M:%S")

if (sys.argv[1] == "test"):
	print "timestamp:    " , str(timestamp)
	print "temperature:  ", str(temperature)
	print "temperature1: ", str(temperature1)
	print "temperature2: ", str(temperature2)
	print "light:        ", str(light)
	print "humidity      ", str(humidity)
else:
	write_log_csv()
	write_log_sql()
