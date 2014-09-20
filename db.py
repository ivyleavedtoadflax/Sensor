import dropbox

#db_app_key_file  = open("db_app_key","r") 
#app_key = db_app_key_file.read()
#db_app_key_file.close()
#db_app_secret_file  = open("db_app_secret","r")
#app_secret = db_app_key_file.read()
#db_app_secret_file.close()

access_token_file = open("access_token","r")
access_token = access_token_file.read()
access_token_file.close()

access_token = access_token.strip()

# Check that we have access:

client = dropbox.client.DropboxClient(access_token)
print 'linked account: ', client.account_info()

f = open('/var/www/Log.db','rb')
response = client.put_file('/R/Sensor/Log.db', f)
