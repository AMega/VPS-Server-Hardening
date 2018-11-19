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
# SSHPORT='55522'

# Update Log File
echo /n >> $LOGFILE 2>&1
echo ------------------------------------------------ >> $LOGFILE 2>&1
echo "--- Server Hardening Script Started -----------">> $LOGFILE 2>&1
echo ------------------------------------------------ >> $LOGFILE 2>&1
echo -e "------------------------------------------------ \n" >> $LOGFILE 2>&1

#################### 
##  2. SSH CONFIG ##
####################
echo ------------------------------------------------
echo "--- 3. SSH CONFIG ------------------------------"

echo -e "------------------------------------------------ \n"
	# Add to log
	echo ------------------------------------------------ >> $LOGFILE 2>&1
	echo "--- 3. SSH CONFIG ------------------------------" >> $LOGFILE 2>&1
	echo ------------------------------------------------ >> $LOGFILE 2>&1	

# Prompt for custom SSH port between 11000 and 65535
function collect_sshd {
	read -p "Please enter a custom SSH port (between 11000 and 65535):  " SSHPORT
        # check if SSHPORT is valid
	if [ $SSHPORT -gt 10999 ] && [ $SSHPORT -lt 65536 ]
	then echo "** Valid ssh port detected **"
	else echo "Invalid SSH port entered, try again"
	collect_sshd
	fi
}

collect_sshd
echo moving on... SSH Port will be set to $SSHPORT
	
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
