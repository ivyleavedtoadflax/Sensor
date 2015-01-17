#cat <<! > raspi-gmail.py
#!/usr/bin/env python

def check():

	import feedparser
	import time, imaplib, email  # could be email not mail
	import sendLog

	USERNAME = "" # just the part before the @ sign, add yours here
	PASSWORD = ""

	# read subject line

	mail = imaplib.IMAP4_SSL('imap.gmail.com')
	#print("Logging on...")
	mail.login(USERNAME,PASSWORD)
	mail.list()
	mail.select('inbox')

	if mail.search(None, '(SUBJECT "TempUpdate")', '(Unseen)') != 0:  ### this needs additional work a[1:] is a start

		# name data as unseen email with TempUpdate as the subject

		typ, data = mail.search(None, '(SUBJECT "TempUpdate")', '(Unseen)') #  This can take the value Unseen or ALL
		
		# mark those unseen email(s) as seen
		
			# convert data into a list
		
		ids = data[0].split()

		for i in ids:
			type, data = mail.fetch( i, '(RFC822)' )

		for response_part in data:
			if isinstance(response_part, tuple):
				msg = email.message_from_string(response_part[1])
				print(email.utils.parseaddr(msg['from'])[1].split())
				timestamp = time.strftime("%Y-%m-%d,%H:%M:%S")
				log1 = open("/home/pi/therm/Sensor/sendLog.csv", "a")
				log1.write("\n" + timestamp + "," + str(email.utils.parseaddr(msg['from'])[0]) + "," + str(email.utils.parseaddr(msg['from'])[1]))
				log1.close()
				sendLog.sendMail(email.utils.parseaddr(msg['from'])[1].split(),
				"TempUpdate",
				"Temperature log graph attached",
				["/home/pi/therm/Sensor/Log.csv"])
#				["/home/pi/therm/Sensor/plots/Log.pdf"])
# 				["/home/pi/therm/plots/Log.pdf", "/home/pi/therm/tempLog.csv"])
				
		for num in ids:
			print "Message " + str(num) + " marked seen and deleted"
			mail.store(num, '+FLAGS', '\\Seen') # can take '\\Deleted' followed by mail.expunge()
			mail.store(num, '+FLAGS', '\\Deleted')
			mail.expunge()
								
		mail.logout()		# This may be required
		
	else: 
		print "Error no update requests found."


