# Sensor

Code for running a raspberry pi powered sensor platform for monitoring internal temperature.

Clone this branch or simply copy sensor.py into /home/pi/Sensor/ and then create a scheduling rule to run the logging program.

Run:

crontab -e

...then enter the following line at the end of the file:

 */3 * * * * cd /home/pi/Sensor; sudo python sensor.py

Make sure that you have the lines:

sudo modprobe w1-gpio
sudo modprobe w1-therm

added in your `/etc/rc.local` file, to initialise the temperature sensor on every reboot.

Alternatively you can add this to crontab with:

`crontab -e`

...then add the lines:

`@reboot sudo modprobe w1-gpio;sudo modprobe w1-therm`



