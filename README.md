# Sensor

Code for running a raspberry pi powered sensor platform for monitoring internal temperature.

Clone this branch or simply copy sensor.py into `/home/pi/Sensor/` and then create a scheduling rule with crontab to run the logging program.

Run:

`crontab -e`

...then enter the following line at the end of the file:

` */3 * * * * cd /home/pi/Sensor; sudo python sensor.py`

Make sure that you have the lines:

`sudo modprobe w1-gpio`
`sudo modprobe w1-therm`

added in your `/etc/rc.local` file, to initialise the temperature sensor on every reboot.

Alternatively you can add this to crontab with:

`crontab -e`

...then add the lines:

`@reboot sudo modprobe w1-gpio;sudo modprobe w1-therm`

A log file (csv) will then be created in your `/home/pi/Sensor/` directory with a temperature reading taken every 3 minutes. The frequency of this reading can be adjusted by editing the crontab entry above. `*/3` means every 3 minutes.

The file should look like:

`2015-02-21 02:07:21,21.25`

...and can be in R using the code:

`temp_data <- read.csv("/home/pi/Sensor/Log.csv")`

Note that if you are running R from the raspberry pi, it needs to be installed, and the latest version is not available from the raspian repository. Installing the latest version of R is not straightforward.

To install the version that is held on the respository run:

`sudo apt-get install r-base`

R can then be called from the command line with simply `R`.

