#!/usr/bin/env python
#
#  raspiLapseCam.py
#
#  Created by James Moore on 28/07/2013.
#  Modified by James Moore on 13/11/2013.
#  Copyright (c) 2013 Fotosyn. All rights reserved.
#
#  Raspberry Pi is a trademark of the Raspberry Pi Foundation.

#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:

#  1. Redistributions of source code must retain the above copyright notice, this
#  list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright notice,
#  this list of conditions and the following disclaimer in the documentation
#  and/or other materials provided with the distribution.>

#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#  The views and conclusions contained in the software and documentation are those
#  of the authors and should not be interpreted as representing official policies,
#  either expressed or implied, of the FreeBSD Project.

# This script sets up and runs a Python Script which, at intervals invokes a capture 
# command to the Raspberry Pi camera, and stores those files locally in a dynamically
# named folder.

# To invoke, copy this script to an easy to find file location on your Raspberry Pi
# (eg. /home/pi/), log into your Raspberry Pi via terminal and type:
#
# sudo python /your/file/location/raspiLapseCam.py (add &) if you wish to run as a
# background task. A process ID will be shown which can be ended with

# sudo kill XXXX (XXXX = process number)

# Based on your settings the application will no begin capturing images
# saving them to your chose file location (same as current location of this file as default.

# Import some frameworks
import os
import time
import RPi.GPIO as GPIO
from datetime import datetime

# Run a WHILE Loop of infinitely


d = datetime.now()
	
# Capture the CURRENT time (not start time as set above) to insert into each capture image filename

year = "%02d" % (d.year)
month = "%02d" % (d.month)
day = "%02d" % (d.day)
hour = "%02d" % (d.hour)
mins = "%02d" % (d.minute)
secs = "%02d" % (d.second)

fileName = str(year) + str(month) + str(day) + "-" + str(hour) + str(mins) + str(secs) + ".jpg"

# Define the size of the image you wish to capture. 
imgWidth = 800 # Max = 2592 
imgHeight = 600 # Max = 1944
print " ====================================== Saving file at " + hour + ":" + mins

# Capture the image using raspistill. Set to capture with added sharpening, auto white balance and average metering mode
# Change these settings where you see fit and to suit the conditions you are using the camera in
os.system("raspistill -w " + str(imgWidth) + " -h " + str(imgHeight) + " -o " + "/var/www/stills/" + fileName + " -sh 40 -awb auto -mm average -v")

try:
	os.system("sudo raspistill -w " + str(imgWidth) + " -h " + str(imgHeight) + " -o " + "/media/usb/" + fileName + " -sh 40 -awb auto -mm average -v")
except:
	pass
		
