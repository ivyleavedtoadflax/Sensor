# Sensor

Code for running a raspberry pi powered sensor platform for monitoring internal and external temperature, light, and humidity.

Latest branch is SensorPiB - will get round to cleaning up the other branches one day.

System currently consists of two DS18b20 onewire temperature sensors, one DHT22 temperature and humidity sensor, and a light dependent resistor (LDR) hooked up to a capacitor to provide a digital output for sensing light. Also added is an Adafruit ultimate GPS module, partly just for practice, and partly because I had a crazy notion of running the whole thing in my car...or something.

Programming for the pis is all in python, graphing is all in R. Currently using Adafruit python driver for DHT22 [https://github.com/adafruit/Adafruit_Python_DHT]([https://github.com/adafruit/Adafruit_Python_DHT]).

## Setting up a raspberry pi

In this guide I explain how I set up my most recent raspberry pi, which is an A+ board. I don't have an external monitor, so this setup is completed entirely headlessly.

### Raspbian

At present I use the standard raspbian image (available [here](http://www.raspberrypi.org/downloads/), not the NOOBS setup), and flash this onto the SD card using `disks` in Ubuntu. In future it would make sense to switch over to a more minimal install of raspbian (e.g. [here](http://www.cnx-software.com/2012/07/31/84-mb-minimal-raspbian-armhf-image-for-raspberry-pi/)).

### Wifi support

After installing Raspbian we need to make sure that the raspberry pi A+ is going to connect ok to the WiFi network. Very simply, all I do is copy the config from `/var/wpa_supplicant/wpa_supplicant.conf`on one of my otehr pis, and paste it into the same location on the new pi. In my case it looks something like this (of course I have removed the passkey):

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

> network={
> 	ssid=""
> 	psk=""
> 	proto=RSN
> 	key_mgmt=WPA-PSK
> 	pairwise=CCMP
> 	auth_alg=OPEN
> 	}

Once that is sorted, I plug in the WiFi adapter (and be careful if you are using an edimax one - these seem to bethicker than normal usb ports, and for some reason I have bent back the usb port pins twice -- on the first occasion I had to send the pi back for a replacement), switch on the pi and it should connect to your network.

You then need to find the IP address of the pi in your router config, then you can ssh to it using `ssh pi@192.168.1.255` or equivalent. The password will of course be raspberry by default.

### Packages

Next thing to do is to install some packages so we can get it working as a sensor.

First we do the standard update:

`sudo apt-get update -y; sudo apt-get upgrade -y`

here the `-y` flag will just download everything without asking you again.

Next python:

`sudo apt-get install python-dev python-rpi.gpio -y`

## GPS

I'm using an Adafruit ultimate GPS module attached over UART. You need to run the following:

```
sudo apt-get install gpsd gpsd-clients python-gps
sudo gpsd /dev/ttyAMA0 -F /var/run/gpsd.sock
```

and then the gps should be visible, in my case on ```/dev/ttyAMA0```, which you can ```cat``` to see the latest data stream. 

To make the gps (GPS demon) run at startup, you need to run:

```sudo dpkg-reconfigure gpsd```

and follow the onscreen prompts. Answer NO when it asks you whether you want it to manage USB GPS devices, as we are using UART.

Attempting to do this caused an error for me relating to the mathkernel. This can be fixed follow the instructions at the forum post [here](http://www.raspberrypi.org/forums/viewtopic.php?f=66&t=68263). essentially, you must add:

```
### BEGIN INIT INFO
# Provides:          mathkernel
# Required-Start:    $local_fs 
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: mathkernel
### END INIT INFO
```
to the file ```/etc/init.d/mathkernel```  after the shebang:

```
 #!bin/sh 
```

## Crontab

Rather than run an infinite python loop, I have started using crontab to run each of the python scripts independently at various intervals. This makes it easier to link up the data collected by varuious raspberry pis, as the timestamps will be the same. The crontab file looks like this:

```
# m h  dom mon dow   command
  */3 * * * *     cd ~/Sensor/; sudo python sensor.py
  */10 * * * *     cd ~/Sensor/; sudo python gpsdData2.py
  */15 * * * *  cd ~/Sensor/; sudo python db.py
  @reboot sudo modprobe w1-gpio
  @reboot sudo modprobe w1-therm
  
```
