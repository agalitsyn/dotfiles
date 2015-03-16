#!/bin/sh

set -x

###
# Ubuntu 14.04
###

# Ask for the administrator password upfront
sudo -v

# Add repos
sh -c 'echo "deb http://archive.canonical.com/ quantal partner" >> /etc/apt/sources.list'
add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:tualatrix/ppa
add-apt-repository -y ppa:shutter/ppa

# Keep newest
apt-get update
apt-get upgrade -y

# Essential
apt-get install -y subversion git vim vim-gtk ctags mc htop smartmontools rar unrar ssh tree curl wget nfs-common ack-grep

# Look
apt-get install -y numix-icon-theme numix-icon-theme-circle numix-wallpaper-halloween numix-gtk-theme

# Ubuntu tweakers
apt-get install -y preload bum unity-tweak-tool compizconfig-settings-manager
# Optional tweak packages: conf-editor dconf-editor gnome-tweak-tool ubuntu-tweak

# Python
apt-get install -y python python-setuptools python3 python3-setuptools python-pip

# Nodejs
apt-get install -y nodejs npm

# Skype + ability to use gtk+ theme
apt-get install -y skype gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386

# Ranger
apt-get install ranger caca-utils highlight atool w3m poppler-utils mediainfo
ranger --copy-config=all

# Java 7
apt-get install -y oracle-java7-installer

# VM
apt-get install -y virtualbox virtualbox-guest-additions-iso

# Fonts
apt-get install -y fonts-droid ttf-mscorefonts-installer

# Remote desktop
apt-get install -y xrdp vino
#echo "gnome-session --session=ubuntu-2d" > ~/.xsession

# AMP
apt-get install -y apache2 php5 php5-common libapache2-mod-php5 libapache2-mod-auth-mysql php5-mysql php5-cli php5-cgi php-pear php5-dev php5-curl php-apc php5-memcache php5-xdebug php5-sqlite php5-pgsql php5-intl

# MySQL
apt-get install -y mysql-server mysql-client phpmyadmin

# Diff tool
apt-get install -y meld

# Keyboard tools
apt-get install -y numlockx parcellite xclip

# Screenshot
apt-get install -y shutter

# Fix broken windows on some apps
gsettings set com.canonical.desktop.interface scrollbar-mode normal

echo "Done."
echo "Suggestions: skype, google-chrome, xmind, yed, plantuml"
