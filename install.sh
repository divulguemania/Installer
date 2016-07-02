#!/usr/bin/env bash
#---------------------------------------------------------------------
# install.sh
#
# Divulgue Mania system installer
#
# Script: install.sh
# Version: 2.0.3
# Author: Bruno Ribeiro <bruno.espertinho@gmail.com>
# Author: Matteo Temporini <temporini.matteo@gmail.com>
# Description: This script will install all the packages needed to install
# Divulgue Mania on your server.
#
#
#---------------------------------------------------------------------

#Those lines are for logging porpuses
exec > >(tee -i /var/log/Divulgue_Mania_setup.log)
exec 2>&1

#---------------------------------------------------------------------
# Global variables
#---------------------------------------------------------------------
CFG_HOSTNAME_FQDN=`hostname -f`;
WT_BACKTITLE="Divulgue Mania System Installer"

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color
bold='\e[1m'
cyan='\e[96m'
yellow='\e[93m'
magenta='\e[35m'

#Saving current directory
PWD=$(pwd);

#---------------------------------------------------------------------
# Load needed functions
#---------------------------------------------------------------------

source $PWD/functions/check_linux.sh
echo "Checking your system, please wait..."
CheckLinux
#---------------------------------------------------------------------
# Load needed Modules
#---------------------------------------------------------------------
echo -e "${red}${bold} Loading needed Modules...";
source $PWD/distros/$DISTRO/preinstallcheck.sh
source $PWD/distros/$DISTRO/askquestions.sh
source $PWD/distros/$DISTRO/askquestions_multiserver.sh
source $PWD/distros/$DISTRO/install_basics.sh
source $PWD/distros/$DISTRO/install_postfix.sh
source $PWD/distros/$DISTRO/install_mysql.sh
source $PWD/distros/$DISTRO/install_mta.sh
source $PWD/distros/$DISTRO/install_antivirus.sh
source $PWD/distros/$DISTRO/install_webserver.sh
source $PWD/distros/$DISTRO/install_ftp.sh
source $PWD/distros/$DISTRO/install_quota.sh
source $PWD/distros/$DISTRO/install_bind.sh
source $PWD/distros/$DISTRO/install_webstats.sh
source $PWD/distros/$DISTRO/install_jailkit.sh
source $PWD/distros/$DISTRO/install_fail2ban.sh
source $PWD/distros/$DISTRO/install_webmail.sh
echo -e "${green}${bold} needed Modules loaded !";
#---------------------------------------------------------------------
# Main program [ main() ]
#    Run the installer
#---------------------------------------------------------------------
clear
echo -e "Welcome to ${cyan}${bold}Divulgue Mania Setup ${green}${bold}Script v.2.0.2${NC}"
echo -e "This software is developed by ${yellow}${bold}Temporini Matteo${NC} and Edited by ${yellow}${bold}Bruno Ribeiro${NC}"
echo "with the support of the community."
echo "You can visit website at the followings URLS from original code"
echo -e "${magenta}${bold}http://www.divulguemania.com${NC}"
echo "========================================="
echo -e " ${cyan}${bold}Divulgue Mania System installer${NC}"
echo "========================================="
echo
echo "This script will do a nearly unattended intallation of"
echo -e "all software needed to run ${cyan}${bold}Dashboard Divulgue Mania${NC}."
echo "When this script starts running, it'll keep going all the way"
echo "So before you continue, please make sure the following checklist is ok:"
echo
echo "- This is a clean standard clean installation for supported systems";
echo "- Internet connection is working properly";
echo
echo
if [ -n "$PRETTY_NAME" ]; then
	echo -e "The detected Linux Distribution is: " $PRETTY_NAME
else
	echo -e "The detected Linux Distribution is: " $ID-$VERSION_ID
fi
echo
if [ -n "$DISTRO" ]; then
	read -p "Is this correct? (y/n)" -n 1 -r
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
		exit 1
	fi
else
	echo -e "Sorry but your System is not supported by this script, if you want your system supported "
	exit 1
fi

if [ $DISTRO == "debian8" ]; then
         while [ "x$CFG_MULTISERVER" == "x" ]
          do
                CFG_MULTISERVER=$(whiptail --title "MULTISERVER SETUP" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Would you like to install Divulgue Mania in a MultiServer Setup?" 10 50 2 "no" "(default)" ON "yes" "" OFF 3>&1 1>&2 2>&3)
          done
fi

if [ -f /etc/debian_version ]; then
  PreInstallCheck
  if [ $CFG_MULTISERVER == "no" ]; then
	AskQuestions
  else
	AskQuestionsMultiserver
  fi
  InstallBasics 
  InstallSQLServer 
  if [ $CFG_SETUP_WEB == "y" ] || [ $CFG_MULTISERVER == "n" ]; then
    InstallWebServer
    InstallFTP 
    if [ $CFG_QUOTA == "y" ]; then
    InstallQuota 
    fi
    if [ $CFG_JKIT == "y" ]; then
    InstallJailkit 
    fi
    InstallWebmail 
  else
    source $PWD/distros/$DISTRO/install_basephp.sh #to remove in feature release
	InstallBasePhp    #to remove in feature release
  fi  
  if [ $CFG_SETUP_MAIL == "y" ] || [ $CFG_MULTISERVER == "n" ]; then
    InstallPostfix 
    InstallMTA 
    InstallAntiVirus 
  fi  
  if [ $CFG_SETUP_NS == "y" ] || [ $CFG_MULTISERVER == "n" ]; then
    InstallBind 
  fi  
  InstallWebStats   
  InstallFail2ban 
  echo -e "${green}Well done Divulgue Mania Setup installed and configured correctly :D ${NC}"
  echo "Now you can connect to your Divulgue Mania Dashboard installation at https://$CFG_HOSTNAME_FQDN or https://IP_ADDRESS"
  echo "You can send customer product for this web server !"
  if [ $CFG_WEBSERVER == "nginx" ]; then
  	if [ $CFG_PHPMYADMIN == "yes" ]; then
  		echo "Phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://IP_ADDRESS:8081/phpmyadmin";
	fi
	if [ $DISTRO == "debian8" ] && [ $CFG_WEBMAIL == "roundcube" ]; then
		echo "Webmail is accessibile at  https://$CFG_HOSTNAME_FQDN/webmail or https://IP_ADDRESS/webmail";
	else
		echo "Webmail is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/webmail or http://IP_ADDRESS:8081/webmail";
	fi
  fi
else 
	if [ -f /etc/centos-release ]; then
		echo "Attention pls, this is the very first version of the script for Centos 7"
		echo "Pls use only for test pourpose for now."
		echo -e "${red}Not yet implemented: courier, nginx support${NC}"
		echo -e "${green}Yet implemented: apache, mysql, bind, postfix, dovecot, roudcube webmail support${NC}"
		echo "Help us to test and implement, press ENTER if you understand what i'm talinkg about..."
		read DUMMY
		PreInstallCheck
		AskQuestions 
		InstallBasics 
		InstallPostfix 
		InstallSQLServer 
		InstallMTA 
		InstallAntiVirus 
		InstallWebServer
		InstallFTP 
		#if [ $CFG_QUOTA == "y" ]; then
		#		InstallQuota 
		#fi
		InstallBind 
        	InstallWebStats 
	    if [ $CFG_JKIT == "y" ]; then
			InstallJailkit 
	    fi
		InstallFail2ban 
		InstallWebmail 
		echo -e "${green}Well done Divulgue Mania Setup installed and configured correctly :D ${NC}"
		echo -e "Now you can connect to your  ${cyan}${bold}Divulgue Mania Setup${NC} installation at ${magenta}${bold} https://$CFG_HOSTNAME_FQDN ${NC} or ${magenta}${bold} https://IP_ADDRESS${NC}"
		echo "You can send customer product for this web server !"
		echo -e "${red}If you setup Roundcube webmail go to ${magenta}${bold} http://$CFG_HOSTNAME_FQDN/roundcubemail/installer ${NC} and configure db connection${NC}"
		echo -e "${red}After that disable access to installer in /etc/httpd/conf.d/roundcubemail.conf${NC}"
	else
		echo "${red}Unsupported linux distribution.${NC}"
	fi
fi

exit 0
