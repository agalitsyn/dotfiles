#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep newest
apt-get update
apt-get upgrade -y

# Essential
apt-get install -y subversion git vim ctags mc htop smartmontools rar unrar ssh tree ack curl wget python-setuptools nfs-common

# Gnome 2
apt-get install -y gnome-session-fallback

# Gnome 2 fix for skype
apt-get install -y sni-qt:i386

# Ubuntu tweakers
apt-get install -y preload bum gconf-editor dconf-editor compizconfig-settings-manager

# Terminal
apt-get install -y terminator

# Java
apt-get install -y openjdk-7-jre

# PHP
apt-get install -y php5 php5-common libapache2-mod-php5 libapache2-mod-auth-mysql php5-mysql php5-cli php5-cgi php-pear php5-dev php5-curl php-apc php5-memcache php5-xdebug

# Apache
apt-get install -y apache2

# MYSQL
apt-get install -y mysql-server mysql-client phpmyadmin

# Devtools
apt-get install -y meld

# VM
apt-get install -y virtualbox virtualbox-guest-additions

# Fonts
apt-get install -y ttf-mscorefonts ttf-droid

# Remote desktop
apt-get install -y xrdp vnc4server
#echo "gnome-session --session=ubuntu-2d" > ~/.xsession
echo "gnome-session --session=gnome-fallback" > ~/.xsession

# Windows shared
apt-get install -y samba cifs cifs-utils

# Notifications
apt-get install -y libnotify-bin

# Additional downloads
echo "Don't forget to install skype oracle-java phpsh chrome shutter remmina-remote-desktop"
echo "Restart computer for taking all changes"
