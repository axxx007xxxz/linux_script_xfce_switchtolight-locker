#!/bin/bash
# Copyright (C) 2017, axxx007xxxz


# Check if the script has been executed as root
if [ $(whoami) != "root" ]; then
    echo "You must run this script as root!"
    exit
fi

# Check if the system has DNF
if [ -f /bin/dnf ]; then
    PKMNG="dnf"
    # In case it's installed somewhere else, the system will automatically redirect all YUM commands to DNF
else
    PKMNG="yum"
fi

# Uninstall xscreensaver
$PKMNG remove -y xscreensaver-*

# Enable needed copr
$PKMNG copr enable -y heikoada/xfce4-addons

# Install light-locker
# DNF/YUM will automatically sync the packages list from the new copr
$PKMNG install -y light-locker light-locker-settings

# If the installation was successful, set the new lock screen command
if [ $? == "0" ]; then
    xfconf-query -c xfce4-session -p /general/LockCommand -s 'light-locker-command -l' --create -t string
    SUCCESS="yes"
fi

# Last stuff
echo
echo
if [[ $SUCCESS == "yes" ]]; then
    echo "Congrats, you've succesfully installed light-locker on your RPM system!"
    echo "You have to reboot in order to start the light-locker service needed to make it working."
else
    echo "Something went wrong."
fi