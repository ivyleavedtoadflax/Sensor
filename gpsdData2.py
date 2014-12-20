#! /usr/bin/python
# -*- coding: utf-8 -*-
# Written by Dan Mandle http://dan.mandle.me September 2012
# License: GPL 2.0

from gps import *
from time import *
import time
import threading
import sqlite3

gpsd = None #seting the global variable

class GpsPoller(threading.Thread):
  def __init__(self):
    threading.Thread.__init__(self)
    global gpsd #bring it in scope
    gpsd = gps(mode=WATCH_ENABLE) #starting the stream of info
    self.current_value = None
    self.running = True #setting the thread running to true

  def run(self):
    global gpsd
    while gpsp.running:
      gpsd.next() #this will continue to loop and grab EACH set of gpsd info to clear the buffer

if __name__ == '__main__':
  gpsp = GpsPoller() # create the thread
  try:
    gpsp.start() # start it up

    i = 0

    while (i < 100):
      lat = gpsd.fix.latitude
      lon = gpsd.fix.longitude
      utc = gpsd.utc
      i += 1
      if (lat == 0.0):
        time.sleep(0.05)
      else:
	# Log into /www/var/Log.db - sqlite3 database
        break
    gpsp.running = False
    gpsp.join()
  except:
    pass

conn = sqlite3.connect("/var/www/SensorPiB.db")
curs = conn.cursor()

curs.execute("INSERT INTO gps values('" + str(utc) + "','" + str(lat) + "','" + str(lon) + "')")

conn.commit()
conn.close()
