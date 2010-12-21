#!/bin/bash
#       _                        
# _   _| |__   _____  _____  ___ 
#| | | | '_ \ / _ \ \/ / _ \/ _ \
#| |_| | |_) | (_) >  <  __/  __/
# \__,_|_.__/ \___/_/\_\___|\___|
# Installation Script

if [[ `whoami` != "root" ]]
then
  echo "Please run this script with sudo or as root"
  exit
fi

echo "Please note, this script is for 64bit users ONLY, press ENTER to continue or CTRL+C to cancel..."
read

echo "Customising Ubuntu please wait..."

echo "Adding repository information..."
sudo add-apt-repository ppa:tualatrix/ppa
wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list
apt-get --quiet update
apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
apt-get --quiet update
apt-get --yes install app-install-data-medibuntu apport-hooks-medibuntu
sudo add-apt-repository ppa:tualatrix/ppa
sudo add-apt-repository ppa:nvidia-vdpau/ppa
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CEC06767
sudo add-apt-repository ppa:team-xbmc-svn/ppa
sudo add-apt-repository ppa:jcfp/ppa
sudo add-apt-repository ppa:tualatrix/ppa
sudo add-apt-repository ppa:pmcenery/ppa
sudo add-apt-repository ppa:ubuntu-wine/ppa
sudo add-apt-repository ppa:deja-dup-team/ppa
sudo add-apt-repository ppa:elementaryart
sudo add-apt-repository ppa:am-monkeyd/nautilus-elementary-ppa
sudo add-apt-repository ppa:gloobus-dev/gloobus-preview
sudo add-apt-repository ppa:awn-testing/ppa
sudo apt-get update
sudo apt-get dist-upgrade

echo "Setting up unattented updates..."
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades

echo "Installing Restricted Extras (installs java, flash and  a few other essential commercial products)"
sudo apt-get install ubuntu-restricted-extras

echo "Installing Ubuntu Tweak..."
sudo apt-get install ubuntu-tweak

echo "Installing Medibuntu..."
apt-get install libdvdcss2
apt-get install w64codecs

echo "Installing Nvidia related drivers and extras..."
sudo apt-get install vdpauinfo libvdpau1 nvidia-current nvidia-190-modaliases nvidia-glx-190 nvidia-settings-190 hd-widescreen-wallpapers

echo "Installing Boxee..."
wget http://dl.boxee.tv/boxee-0.9.22.13692.i486.modfied.deb --output-document=/tmp/boxee.deb
dpkg -i /tmp/boxee.deb
rm -f /tmp/boxee.deb

echo "Installing XBMC Media Center..."
sudo apt-get install xbmc

echo "Installing sabnzbdplus..."
sudo apt-get install sabnzbdplus

echo "Installing Ubuntu Tweak..."
sudo apt-get install ubuntu-tweak

echo "Installing IPhone driver..."
sudo apt-get install gvfs ipheth-utils

echo "Installing Official Java Package..."
sudo apt-get install sun-java6-jdk

echo "Installing Wine..."
sudo apt-get install wine

echo "Installing Deja-Dup Backup..."
sudo apt-get install deja-dup

echo "Installing Elementary Theme..."
sudo apt-get install elementaryart
nautilus -q

echo "Installing Gloobus..."
sudo apt-get install gloobus-preview

echo "Installing AWN..."
sudo apt-get install awn

#echo "Installing Google Chrome..."
#sudo apt-get remove firefox
#wget http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output-document=/tmp/chrome.deb
#dpkg -i /tmp/chrome.deb
#rm -f /tmp/chrome.deb

echo "+-------------------------------------------------+"
echo "| All customisations applied, have a nice day! :) |"
echo "+-------------------------------------------------+"
