#!/usr/bin/env python2.7
import smtplib, string, subprocess
# pifind.py by Alex Eames http://RasPi.tv
# pifind.py gets the system parameters you want to know and 
# emails them through gmail to a destination of your choice

# INSTALLING pifind
# Add this line to /etc/rc.local
#   python /home/pi/pifind.py
# And place this file, pifind.py in your /home/pi folder, then
#   sudo chmod 755 /home/pi/pifind.py

# Settings
fromaddr = 'ivyleavedtoadflax@gmail.com'  
toaddr  = 'ivyleavedtoadflax@gmail.com'  

PW = open("PWORD","r")
PassWord = PW.read()
PW.close()


# Googlemail login details
username = 'ivyleavedtoadflax@gmail.com'  
password = PassWord  

output_if = subprocess.Popen(['ifconfig'], stdout=subprocess.PIPE).communicate()[0]
output_cpu = open('/proc/cpuinfo', 'r').read()

BODY = string.join((
        "From: %s" % fromaddr,
        "To: %s" % toaddr,
        "Subject: Your RasPi just booted",
        "",
        output_if,
        output_cpu,
        ), "\r\n")
      
# send the email  
server = smtplib.SMTP('smtp.gmail.com:587')  
server.starttls()  
server.login(username,password)  
server.sendmail(fromaddr, toaddr, BODY)  
server.quit()

# emailing code from http://www.nixtutor.com/linux/send-mail-through-gmail-with-python/
# BODY bit http://www.blog.pythonlibrary.org/2010/05/14/how-to-send-email-with-python/
