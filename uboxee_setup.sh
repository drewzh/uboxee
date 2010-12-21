#!/bin/bash
#        __                            
#.--.--.|  |--.-----.--.--.-----.-----.
#|  |  ||  _  |  _  |_   _|  -__|  -__|
#|_____||_____|_____|__.__|_____|_____|
#                          Setup Script

if [[ `whoami` != "root" ]]
then
  echo "Please run this script with sudo or as root"
  exit
fi

echo "Please note, this script is for 64bit users ONLY, press ENTER to continue or CTRL+C to cancel..."
read

#VARIABLES
architecture=`uname -m`

wizard(){
    echo "Customising Ubuntu please wait..."

    echo "Adding repository information..."
    add-apt-repository ppa:tualatrix/ppa
    wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list
    apt-get --quiet update
    apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
    apt-get --quiet update
    apt-get --yes install app-install-data-medibuntu apport-hooks-medibuntu
    add-apt-repository ppa:tualatrix/ppa
    add-apt-repository ppa:nvidia-vdpau/ppa
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CEC06767
    add-apt-repository ppa:team-xbmc-svn/ppa
    add-apt-repository ppa:jcfp/ppa
    add-apt-repository ppa:tualatrix/ppa
    add-apt-repository ppa:pmcenery/ppa
    add-apt-repository ppa:ubuntu-wine/ppa
    add-apt-repository ppa:deja-dup-team/ppa
    add-apt-repository ppa:elementaryart
    add-apt-repository ppa:am-monkeyd/nautilus-elementary-ppa
    add-apt-repository ppa:gloobus-dev/gloobus-preview
    add-apt-repository ppa:awn-testing/ppa
    apt-get update
    apt-get dist-upgrade

    echo "Setting up unattented updates..."
    apt-get install unattended-upgrades
    dpkg-reconfigure unattended-upgrades
    
    echo "Installing SSH..."
    apt-get install openssh-server

    echo "Installing Restricted Extras (installs java, flash and  a few other essential commercial products)"
    apt-get install ubuntu-restricted-extras

    echo "Installing Ubuntu Tweak..."
    apt-get install ubuntu-tweak

    echo "Installing Medibuntu..."
    apt-get install libdvdcss2
    if [ "$architecture" != "x86_64" ] && [ "$architecture" != "ia64" ]; then
        apt-get install w32codecs
    else
        apt-get install w64codecs
    fi    

    echo "Installing Nvidia related drivers and extras..."
    apt-get install vdpauinfo libvdpau1 nvidia-current nvidia-190-modaliases nvidia-glx-190 nvidia-settings-190 hd-widescreen-wallpapers

    echo "Installing Boxee..."
    if [ "$architecture" != "x86_64" ] && [ "$architecture" != "ia64" ]; then
        wget http://dl.boxee.tv/boxee-0.9.22.13692.i486.modfied.deb --output-document=/tmp/boxee.deb
    else
        wget http://dl.boxee.tv/boxee-0.9.22.13692.x86_64.modfied.deb --output-document=/tmp/boxee.deb
    fi
        
    dpkg -i /tmp/boxee.deb
    rm -f /tmp/boxee.deb

    echo "Installing XBMC Media Center..."
    apt-get install xbmc

    echo "Installing sabnzbdplus..."
    apt-get install sabnzbdplus

    echo "Installing Ubuntu Tweak..."
    apt-get install ubuntu-tweak

    echo "Installing IPhone driver..."
    apt-get install gvfs ipheth-utils

    echo "Installing Official Java Package..."
    apt-get install sun-java6-jdk

    echo "Installing Wine..."
    apt-get install wine

    echo "Installing Deja-Dup Backup..."
    apt-get install deja-dup

    echo "Installing Elementary Theme..."
    apt-get install elementaryart
    nautilus -q

    echo "Installing Gloobus..."
    apt-get install gloobus-preview

    echo "Installing AWN..."
    apt-get install awn

    echo "Installing Google Chrome..."
    apt-get remove firefox
    
    echo "Installing Boxee..."
    if [ "$architecture" != "x86_64" ] && [ "$architecture" != "ia64" ]; then
        wget http://dl.google.com/linux/direct/google-chrome-unstable_current_i386.deb --output-document=/tmp/chrome.deb
    else
        wget http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output-document=/tmp/chrome.deb
    fi
    
    dpkg -i /tmp/chrome.deb
    rm -f /tmp/chrome.deb

    #echo "Installing boxee splash screen..."
    #update-alternatives --install /usr/lib/usplash/usplash-artwork.so usplash-artwork.so /usr/lib/usplash/usplash-theme-boxee.so 55
    
    echo "+-------------------------------------------------+"
    echo "| All customisations applied, have a nice day! :) |"
    echo "+-------------------------------------------------+"
}

printBanner(){
    printMsg "        __                            "
    printMsg ".--.--.|  |--.-----.--.--.-----.-----."
    printMsg "|  |  ||  _  |  _  |_   _|  -__|  -__|"
    printMsg "|_____||_____|_____|__.__|_____|_____|"
}

printMsg(){
    echo -e "\033[1m$1\033[0m"
}

printError(){
    echo -e "\033[1;31m$1\033[0m"
}

printSuccess(){
    echo -e "\033[1;32m$1\033[0m"
}

basicMenu(){
    printMsg "+-----------------------------------------+"
    printMsg "| Please select an option and hit <enter> |"
    printMsg "+-----------------------------------------+"
    printMsg "| 1) Start wizard                         |"
    printMsg "| 2) Switch to advanced mode              |"
    printMsg "| 3) Quit                                 |"
    printMsg "+-----------------------------------------+"
}

advancedMenu(){
    printMsg "+-----------------------------------------+"
    printMsg "| Please select an option and hit <enter> |"
    printMsg "+-----------------------------------------+"
    printMsg "| 1) Install boxee                        |"
    printMsg "| 2) Switch to basic mode                 |"
    printMsg "| 3) Quit                                 |"
    printMsg "+-----------------------------------------+"
}

while [ 1 ]; do
    printBanner
    case $var_menutype in
    "basic")
        basicMenu
        read CHOICE
        case "$CHOICE" in
        "1")
            wizard
            ;;
        "2")
            var_menutype="advanced"
            continue
            ;;
        "3")
            exit
            ;;
        esac
    ;;
    "advanced")
        advancedMenu
        read CHOICE
        case "$CHOICE" in
        "1")
            # Do nothing yet
            ;;
        "2")
            var_menutype="basic"
            continue
            ;;
        "3")
            exit
            ;;
        esac
    esac
done