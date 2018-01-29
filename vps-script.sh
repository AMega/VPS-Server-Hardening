#!/bin/bash
# Script to Harden Security on Ubuntu
# 

# 1. USER SETUP / Add new user (amega) / Add to sudo group
# 2. SSH CONFIG / Change SSH port , disable root login
# 3. CONFIG FIREWALL / UFW - add IN rules, default IN / OUT rules, Enable firewall
# 4. ADD FAIL2BAN / install F2B, edit config to enable new SSH port
# 5. RUBY ON RAILS / install node.js , install ruby, rails, 

# Add to log command
# echo "`date +%d.%m.%Y" "%H:%M:%S` : $MESSAGE" >> $LOGFILE 2>&1
# SKIP output:    > /dev/null 2>&1


# Set Vars
LOGFILE='/var/log/server_hardening.log'
SSHDFILE='/etc/ssh/sshd_config'
SSHPORT='55522'

# Update Log File
echo /n >> $LOGFILE 2>&1
echo ------------------------------------------------ >> $LOGFILE 2>&1
echo "--- Server Hardening Script Started -----------">> $LOGFILE 2>&1
echo ------------------------------------------------ >> $LOGFILE 2>&1
echo -e "------------------------------------------------ \n" >> $LOGFILE 2>&1


##########################
## 1. UPDATE & UPGRADE ###
##########################
echo ------------------------------------------------
echo "--- 1. UPDATE and UPGRADE ------------------------"
echo -e "------------------------------------------------ \n"


	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 1. UPDATE and UPGRADE ------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "`date +%d.%m.%Y_%H:%M:%S` : INITIALISE SYSTEM UPDATE ">> $LOGFILE 2>&1

apt-get update
echo ------------------------------------------------
	# add to log 
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "`date +%d.%m.%Y_%H:%M:%S` : INITIALISE SYSTEM UPGRADE ">> $LOGFILE 2>&1

	
apt-get upgrade -y
echo -e "------------------------------------------------ \n"

	# add to log 
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "`date +%d.%m.%Y_%H:%M:%S` : SYSTEM UPDATED and UPGRADED SUCCESFULLY " >> $LOGFILE 2>&1



#################### 
## 2. USER SETUP ###
####################
echo ------------------------------------------------
echo "--- 2. USER SETUP ------------------------------"
echo -e "------------------------------------------------ \n"
	
	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 2. USER SETUP ------------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo -e "\n"

read -p "Enter New USERNAME" uname

id -u $uname >> $LOGFILE > /dev/null 2>&1
if [ $? -eq 0 ] 
then
	echo " SKIPPING. User Already Exists."
	echo ------------------------------------------------
	echo "`date +%d.%m.%Y_%H:%M:%S` : SKIPPING : User amega Already Exists ! " >> $LOGFILE 2>&1
else 
	adduser $uname
	usermod -aG sudo $uname >> $LOGFILE 2>&1
	echo " SUCCESS : User $uname has been created and Added to SUDO group ! "
	echo "`date +%d.%m.%Y_%H:%M:%S` : SUCCESS : User $uname has been created and Added to SUDO group ! " >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1
fi
	
echo -e "------------------------------------------------ \n"

	
	
#################### 
##  3. SSH CONFIG ##
####################
echo ------------------------------------------------
echo "--- 3. SSH CONFIG ------------------------------"
echo -e "------------------------------------------------ \n"
	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 3. SSH CONFIG ------------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1	
	
# Take a backup of the existing config
cat /etc/ssh/sshd_config > /etc/ssh/sshd_config.$(date +%F_%R).bak >> $LOGFILE 2>&1
echo " SSH Config File Backed up "
# Give user amega permissions to all files in /etc/ssh/sshd_config
chmod 777 /etc/ssh/sshd_config.$(date +%F_%R).bak >> $LOGFILE 2>&1

echo -e "------------------------------------------------ \n"
	
	# Add to log
	echo "`date +%d.%m.%Y_%H:%M:%S` : SSH Config File Backed up " >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	
  
# Change default Port
sed -i "s/Port 22/Port $SSHPORT/" /etc/ssh/sshd_config >> $LOGFILE 2>&1

	# Error Handling
	if [ $? -eq 0 ] 
	then
		echo " SUCCESS : SSH Port changed to $SSHPORT "
		echo "`date +%d.%m.%Y_%H:%M:%S` : SUCCESS : SSH Port changed to $SSHPORT " >> $LOGFILE 2>&1
	else 
		echo " ERROR: SSH Port couldn't be changed. Check log file for details."
		echo "`date +%d.%m.%Y_%H:%M:%S` : ERROR: SSH Port couldn't be changed " >> $LOGFILE 2>&1;
	fi

# Deny Root login
#sed -i "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config >> $LOGFILE 2>&1

	# Error Handling
	#if [ $? -eq 0 ] 
	#then
		#echo " SUCCESS : Permit Root login changed to NO "
		#echo "`date +%d.%m.%Y_%H:%M:%S` : SUCCESS : Permit Root login changed to NO " >> $LOGFILE 2>&1
	#else 
		#echo " ERROR: Permit Root login couldn't be changed."
		#echo "`date +%d.%m.%Y_%H:%M:%S` : ERROR: Permit Root login couldn't be changed : " >> $LOGFILE 2>&1
	#fi

echo -e "------------------------------------------------ \n"	
	
#################### 
##  4. FW CONFIG ###
####################
echo ------------------------------------------------
echo "--- 4. FW CONFIG -------------------------------"
echo -e "------------------------------------------------ \n"

	#add to Log File
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 4. FW CONFIG -------------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	
	# Chech if installed
	ufw status > /dev/null 2>&1
	if [ $? -eq 0 ] 
	then
		echo "-- SKIPPING : UFW already installed. Moving on... ! "
		echo "`date +%d.%m.%Y_%H:%M:%S` : SKIPPING : UFW already installed. Moving on... ! " >> $LOGFILE 2>&1
	else 
		echo "-- INFO : UFW NOT installed. Installing now... !"
		echo "`date +%d.%m.%Y_%H:%M:%S` : INFO : UFW NOT installed. Installing now... ! " >> $LOGFILE 2>&1
		apt-get install ufw -y >> $LOGFILE 2>&1
	fi

ufw allow 80 >> $LOGFILE 2>&1
ufw allow 443 >> $LOGFILE 2>&1
ufw allow 55522 >> $LOGFILE 2>&1
ufw default allow outgoing >> $LOGFILE 2>&1
ufw default deny incoming >> $LOGFILE 2>&1

echo "Current Firewall Rules:"
echo ------------------------------------------------
ufw show added
echo -e "------------------------------------------------ \n"


read -p "Enable the Firewall ? [y/n]" fwenable 

	if [ $fwenable = "Y" ] || [ $fwenable = "y" ]
	then
		ufw enable
	else
		echo "Firewall NOT Enabled"
		
	fi
	
	
echo -e "------------------------------------------------ \n"

#################### 
##  5. F2B Config ##
####################

#echo "--- 5. F2B Config ------------------------------" >> $LOGFILE 2>&1
#echo ------------------------------------------------ >> $LOGFILE 2>&1



######################
##  6. Ruby Install ##
######################


#echo "--- 6. Ruby Install ----------------------------" >> $LOGFILE 2>&1
#echo ------------------------------------------------ >> $LOGFILE 2>&1


###########################
##  9. NEOFETCH Install  ##
###########################
echo ------------------------------------------------
echo "--- 9. NEOFETCH Install -----------------------"
echo -e "------------------------------------------------ \n"
	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 9. NEOFETCH Install -----------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1	
	echo -e ' \n'
	
# Chech if installed
	nefotech --version > /dev/null 2>&1
	if [ $? -eq 0 ] 
	then
		echo "SKIPPING : NEOFETCH already installed. Moving on... ! "
		echo "`date +%d.%m.%Y_%H:%M:%S` : SKIPPING : NEOFETCH already installed. Moving on... ! " >> $LOGFILE 2>&1
	else 
		echo " INFO : NEOFETCH NOT installed. Installing now... !"
		echo "`date +%d.%m.%Y_%H:%M:%S` : INFO : NEOFETCH NOT installed. Installing now... ! " >> $LOGFILE 2>&1
		add-apt-repository ppa:dawidd0811/neofetch >> $LOGFILE 2>&1
		apt update >> $LOGFILE 2>&1
		apt install neofetch >> $LOGFILE 2>&1
		echo -e ' \n'
			
			# Adding NEOFETCH to MOTD
			
			if [ -e /etc/update-motd.d/59-neofetch ] 
			then
				echo " SKIPPING : NEOFETCH Already added to MOTD"
				echo "`date +%d.%m.%Y_%H:%M:%S` : SKIPPING : NEOFETCH Already added to MOTD" >> $LOGFILE 2>&1
			else	
				echo " INFO : Adding NEOFETCH to MOTD"
				echo "`date +%d.%m.%Y_%H:%M:%S` : INFO : Adding NEOFETCH to MOTD" >> $LOGFILE 2>&1
				
				add-apt-repository ppa:dawidd0811/neofetch >> $LOGFILE 2>&1
				apt update >> $LOGFILE 2>&1
				apt install neofetch >> $LOGFILE 2>&1
				
				echo "#!/bin/bash" >> /etc/update-motd.d/59-neofetch >> $LOGFILE 2>&1
				echo "echo -e ' \n'" >> /etc/update-motd.d/59-neofetch >> $LOGFILE 2>&1
				echo neofetch >> /etc/update-motd.d/59-neofetch >> $LOGFILE 2>&1
				echo "echo -e ' \n'" >> /etc/update-motd.d/59-neofetch >> $LOGFILE 2>&1
				
				chmod +x /etc/update-motd.d/59-neofetch >> $LOGFILE 2>&1			
			fi
	
	fi
	
	# Commands

	
	echo -e "------------------------------------------------ \n"

########################
##  10. MOTD Cleanup  ##
########################
echo ------------------------------------------------
echo "--- 10. MOTD Cleanup ----------------------------"
echo -e "------------------------------------------------ \n"
	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 10. MOTD Cleanup ----------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1	

	# Check for header file	
	if [ -e /etc/update-motd.d/00-header ] 
	then
		echo "MOTD Header file Found. DELETING..."
		echo "MOTD Header file Found. DELETING..." >> $LOGFILE 2>&1
		rm /etc/update-motd.d/00-header -f >> $LOGFILE 2>&1
	else
		echo "MOTD Help file NOT Found. SKIPPING..."
		echo "MOTD Help file NOT Found. SKIPPING..." >> $LOGFILE 2>&1
	fi

	# Check for help file
	if [ -e /etc/update-motd.d/10-help-text ] 
	then
		echo "MOTD Help file Found. DELETING..."
		echo "MOTD Help file Found. DELETING..." >> $LOGFILE 2>&1
		rm /etc/update-motd.d/10-help-text -f >> $LOGFILE 2>&1
	else
		echo "MOTD Help file NOT Found. SKIPPING..."
		echo "MOTD Help file NOT Found. SKIPPING..." >> $LOGFILE 2>&1
	fi

		
	# Check for legal file	
	if [ -e /etc/legal ] 
	then
		echo "MOTD Legal file Found. DELETING..."
		echo "MOTD Legal file Found. DELETING..." >> $LOGFILE 2>&1
		rm /etc/legal -f >> $LOGFILE 2>&1
	else
		echo "MOTD Legal file NOT Found. SKIPPING..."
		echo "MOTD Legal file NOT Found. SKIPPING..." >> $LOGFILE 2>&1
	fi

