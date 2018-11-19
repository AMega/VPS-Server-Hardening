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

read -p "Enter New USERNAME:  " uname

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
