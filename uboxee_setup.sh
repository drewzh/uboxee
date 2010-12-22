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

#############
## OPTIONS ##
#############
# Set default menu type
var_menutype="basic"
# Set CPU architecture type
architecture=`uname -m`
# Get ubuntu codename
var_codename=`lsb_release -c | awk '{print $2}'`
# Log file
var_log=/var/log/uboxee.log

function info(){
    echo $@ | tee -a ${var_log}
}

function install(){
    info "Installing $@..."
    apt-get install -qq --force-yes $@ >> $var_log 2>&1
}

function add_repo(){
    apt-add-repository $1 >> $var_log 2>&1
}

function enableAutoUpdate() {
    sed -i '4s|//|  |g' /etc/apt/apt.conf.d/50unattended-upgrades
    sed -i 's|//Unattended-Upgrade::Mail|Unattended-Upgrade::Mail|g' /etc/apt/apt.conf.d/50unattended-upgrades
    sed -i 's|APT::Periodic::Download-Upgradeable-Packages "0";|APT::Periodic::Download-Upgradeable-Packages "1";|g' /etc/apt/apt.conf.d/10periodic
    sed -i 's|APT::Periodic::AutocleanInterval "0";|APT::Periodic::AutocleanInterval "1";|g' /etc/apt/apt.conf.d/10periodic
    echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic
}

function wizard(){
    info "Customising Ubuntu please wait..."

    info "Adding repository information..."
    add_repo "ppa:nvidia-vdpau/ppa"
    add_repo "'deb http://apt.boxee.tv/ $var_codename main'"
    add_repo "ppa:pmcenery/ppa"
    add_repo "ppa:sevenmachines/flash"
    info "Updating repositories and upgrading..."
    apt-get update -qq
    apt-get dist-upgrade

    # Disable console blanking
    setterm -blank 0

    install "unattended-upgrades"
    enableAutoUpdate
    install "openssh-server"
    install "flashplugin64-installer"

    info "Installing Nvidia related drivers and extras..."
    install "libvdpau1 nvidia-185-libvdpau"
    nvidia-xconfig
    # Disable compiz
    su $USER -c 'metacity --replace &'
    
    info "Disabling screensaver timeout..."
    gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

    info "Disabling monitor sleep timeout..."
    gconftool-2 -s /apps/gnome-power-manager/ac_sleep_display --type=int 0

    info "Unmuting HDMI spdif channels..."
    amixer sset 'IEC958 Default PCM' unmute
    amixer sset 'IEC958,0' unmute
    amixer sset 'IEC958,1' unmute 
    
    install "boxee"

    install "gvfs ipheth-utils"
    
    # Add user to fuse group
    usermod -a -G fuse $USER

    #info "Installing boxee splash screen..."
    #update-alternatives --install /usr/lib/usplash/usplash-artwork.so usplash-artwork.so /usr/lib/usplash/usplash-theme-boxee.so 55
    
    # Clean up
    apt-get clean
    apt-get -y autoremove

    info "+-------------------------------------------------+"
    info "|               !!!IMPORTANT !!!                  |"
    info "|               ----------------                  |"
    info "| Please reboot, load Boxee and go to...          |"
    info "| - Settings > Media > Advanced                   |"
    info "|   Uncheck hardware assisted decoding and select |"
    info "|   VDPAU in the render method selection.         |"
    info "| - Restart Boxee                                 |"
    info "|                  ALL DONE!                      |"
    info "+-------------------------------------------------+"
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

menu(){
    printMsg "+------------------------------------+"
    printMsg "|  Select an option and hit <enter>  |"
    printMsg "+------------------------------------+"
    printMsg "| 1) Start wizard                    |"
    printMsg "| 2) Quit                            |"
    printMsg "+------------------------------------+"
}

while [ 1 ]; do
    printBanner
    menu
    read CHOICE
    case "$CHOICE" in
    "1")
        wizard
        ;;
    "2")
        exit
        ;;
    esac
done
