#! /usr/bin/python
# -*- coding: utf-8 -*-
# Written by Dan Mandle http://dan.mandle.me September 2012
# License: GPL 2.0

from gps import *
from time import *
import time
import threading

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

    while True:
      lat = gpsd.fix.latitude
      lon = gpsd.fix.longitude
      utc = gpsd.utc
      if (lat == 0.0):
        time.sleep(0.05)
      else:
        print lat
        print lon
        print utc
        break

    gpsp.running = False
    gpsp.join() # wait for the thread to finish what it's doing
  except:
    pass
