# Znuny-Discord-Notification
- Znuny ticket notification to Discord users via webservices
- Required at least Znuny LTS / Znuny Features

		- This is only for Notification Owner Update.
		- For others kind of notification, kindly create another Invoker. You may refer existing invoker (Owner Update) and existing HTTP::REST Configuration.
		- For the sake of simplicity, we will use perl script to open a channel ID with Discord instead using webservice.
		- OTRS / Znuny will use this opened Channel ID to send the DM Notification to the users via webservice.

***
1. Create a Discord App and configure a bot. 
   
   Reference: https://discord.com/developers/docs/getting-started#step-1-creating-an-app

	a) **Take a note of bot token. e.g: abcdefghijklmn123456789**

	b) For know, step 1 should be enough.
***
2. Import the 'Discord Notification.yml' via Admin > Web Services.
***
3. Update the Discord Bot Token (1a) at the created webservice.

	a) OTRS / Znuny as requester > Network transport (HTTP::REST) > Configure
	
	b) Authorization : Bot <DISCORD_BOT_TOKEN>
	
		E.g: Bot abcdefghijklmn123456789

	c) Save and finish
	
***
4. Import and deploy ZZZAgentDiscord.xml at $OTRS_HOME/Kernel/Config/Files/XML/
***
5. Import discord.pl at at $OTRS_HOME/scripts/ and assign proper permission and update bot token (1a)

		(-) Authorization => 'Bot <DISCORD_BOT_TOKEN>',
		(+) Authorization => 'Bot abcdefghijklmn123456789',
***
6. a) Obtain the Discord ID for the users from Discord App

		- Click User Setting.  
		- Click the more icon "..."  
		- Click on "Copy User ID."  

	b) execute discord.pl	
	
		- this scripts will open an DM channel between bot and selected agent.
		- this scripts will update agent personal preferences -> Miscellaneous > User Discord Channel ID field with Discord Channel ID value.
		- you need to enter Discord User ID obtained from 6(a) above.
		- this script only need to run once per agents / users.
***	
7. Create a new Ticket Notification  

		- Event: NotificationOwnerUpdate
		- Select Recipients: (Should be owners)
		- Select Notification Methods: Webservices 
			-- Web service name: Discord Notification
			-- Invoker: Owner Update 
		
		- Notification Body and Text
			-- Anything as the actual value is set from XSLT itself.
***			
8. **Make sure the Discord User is within same channel as Discord Bot.**

![discord-dm](https://i.postimg.cc/Nj6NxzR5/discord-dm.png)