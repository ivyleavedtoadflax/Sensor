# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import datetime as dt
import scipy as sci
from math import log

# Load the data as a dataframe

def daily_plot():

	logNames = ['date','time','temp1','temp2','light','humidity','PIR']
	logTab = pd.read_table('Log.csv', sep = ',', header = None,  names = logNames)

	# Convert date and time to timeseries object...
	# I think these values are separated in the original sensor.py
	# so it would make more sense not to split them there, and then
	# skip this step here.

	logTab['ts'] = pd.to_datetime(logTab['date'] + " " + logTab['time'])

	# Create individual dataframes for each timeseries here so they can be filtered.
	# Probably a better way of doign this without assigning new variables

	temp1 = pd.DataFrame(logTab[['ts','temp1']])
	temp2 = pd.DataFrame(logTab[['ts','temp2']])
	humidity = pd.DataFrame(logTab[['ts','humidity']])
	light = pd.DataFrame(logTab[['ts','light']])

	# Filter variable to remove all values which are too low or too high

	temp1 = temp1[(temp1['temp1'] > 0) & (temp1['temp1'] < 100)]
	temp2 = temp2[(temp2['temp2'] > 0) & (temp2['temp2'] < 100)]
	humidity = humidity[(humidity['humidity'] > 0) & (humidity['humidity'] < 100)]
	light = light[(light['light'] > 0)]

	# log the light sensor values to make them more understandable

	light['light'] = light['light'].astype('float64').apply(log)

	# produce plot

	plt.subplot(3, 1, 1)
	plt.plot(temp1['ts'],temp1['temp1'])

	plt.subplot(3, 1, 1)
	plt.plot(temp2['ts'],temp2['temp2'])

	plt.subplot(3, 1, 2)
	plt.plot(humidity['ts'],humidity['humidity'])

	plt.subplot(3, 1, 3)
	plt.gca().invert_yaxis()
	plt.plot(light['ts'],light['light'])

	#plt.savefig("/var/www/gfx/daily_temp_plot.png")
	plt.savefig("test.png")

daily_plot()
