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
> 	ssid="EE-BrightBox-57asdk"
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

