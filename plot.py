# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg') # sort out raspberry pi plotting issue
import matplotlib.pyplot as plt
import datetime as dt
import scipy as sci
from math import log
import sqlite3
# Load the data as a dataframe

def daily_plot():

	#logNames = ['date','time','temp1','temp2','light','humidity','PIR']
	#logTab = pd.read_table('Log.csv', sep = ',', header = None,  names = logNames)

	#or read it from the database?

	conn=sqlite3.connect("/var/www/Log.db")
	curs=conn.cursor()

	logTab = pd.DataFrame(curs.execute("select * from temp;").fetchall())
	logTab = ['timestamp','temp1','temp2','light','humidity','PIR']
	
	logTab['timestamp'] = pd.to_datetime(logTab['timestamp'])

	conn.close()	

	# Assign plotting dataframes so they can be filtered
	# Probably a better way of doign this without assigning new variables
	
	temp1 = pd.DataFrame(logTab[['timestamp','temp1']])
	temp2 = pd.DataFrame(logTab[['timsetamp','temp2']])
	humidity = pd.DataFrame(logTab[['timsestamp','humidity']])
	light = pd.DataFrame(logTab[['timsestamp','light']])

        temp_iqr = np.percentile(temp1['temp1'],75) - np.percentile(temp1['temp1'],25)
        temp_upper_limit = np.percentile(temp1['temp1'],75) + (3 * temp_iqr)

	# Filter variable to remove all values which are too low or too high

	temp1 = temp1[(temp1['temp1'] > 0) & (temp1['temp1'] < temp_upper_limit)]
	temp2 = temp2[(temp2['temp2'] > 0) & (temp2['temp2'] < temp_upper_limit)]
	humidity = humidity[(humidity['humidity'] > 0) & (humidity['humidity'] < 100)]
	light = light[(light['light'] > 0)]

	# log the light sensor values to make them more understandable

	light['light'] = light['light'].astype('float64').apply(log)

	# produce plot

	plt.subplot(3, 1, 1)
	plt.plot(temp1['timestamp'],temp1['temp1'])

	plt.subplot(3, 1, 1)
	plt.plot(temp2['timestamp'],temp2['temp2'])

	plt.subplot(3, 1, 2)
	plt.plot(humidity['timestamp'],humidity['humidity'])

	plt.subplot(3, 1, 3)
	plt.gca().invert_yaxis()
	plt.plot(light['timestamp'],light['light'])

	plt.savefig("/var/www/gfx/daily_temp_plot.png")
	#plt.savefig("test.png")

daily_plot()
