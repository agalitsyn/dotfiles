#!/bin/sh

set -x

###
# Linux Mint based in Ubuntu 14.04
###

# Add repos
#sh -c 'echo "deb http://archive.canonical.com/ quantal partner" >> /etc/apt/sources.list'
add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:shutter/ppa
apt-add-repository -y ppa:ansible/ansible

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y make gcc software-properties-common

# Essential
apt-get install -y subversion git gitk vim vim-gtk ctags mc htop smartmontools rar unrar ssh tree curl wget nfs-common ack-grep tmux screen

# Look
apt-get install -y numix-icon-theme numix-icon-theme-circle numix-gtk-theme

# Python
apt-get install -y python python-dev python-setuptools python3 python3-setuptools python-pip

# Nodejs
apt-get install -y nodejs nodejs-legacy npm

# VM
apt-get install -y virtualbox virtualbox-guest-additions-iso

curl -sSL https://get.docker.com/ubuntu/ | sh
apt-get install -y vagrant ansible

# Fonts
apt-get install -y fonts-droid ttf-mscorefonts-installer

# Keyboard tools
apt-get install -y parcellite xclip

# Screenshot
apt-get install -y shutter

# Term
apt-get install -y terminator

# Charts
apt-get install -y graphviz

# Editors
apt-get install -y sublime-text

# IM
apt-get install -y skype

# Cloud
apt-get install -y dropbox

# Remove packages
apt-get purge -y avahi-daemon

echo "Done."
echo "Suggestions: google-chrome, xmind, yed, pycharm."
