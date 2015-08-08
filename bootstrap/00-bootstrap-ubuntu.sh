#!/bin/sh

set -x

###
# Ubuntu 14.04
###

# Add repos
sh -c 'echo "deb http://archive.canonical.com/ quantal partner" >> /etc/apt/sources.list'
add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:tualatrix/ppa
add-apt-repository -y ppa:shutter/ppa
apt-add-repository -y ppa:ansible/ansible

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y make gcc software-properties-common

# Essential
apt-get install -y subversion git vim vim-gtk ctags mc htop smartmontools rar unrar ssh tree curl wget nfs-common ack-grep

# Look
apt-get install -y numix-icon-theme numix-icon-theme-circle numix-wallpaper-halloween numix-gtk-theme

# Ubuntu tweakers
apt-get install -y unity-tweak-tool compizconfig-settings-manager compiz-plugins compiz-plugins-extra dconf-editor gnome-tweak-tool
# Optional optimizers: preload bum

# Claws-mail
apt-get install -y claws-mail claws-mail-extra-plugins

# Skype + ability to use gtk+ theme
apt-get install -y skype gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386

# Ranger (optional)
# apt-get install ranger caca-utils highlight atool w3m poppler-utils mediainfo
# ranger --copy-config=all

# Java 7
apt-get install -y oracle-java7-installer

# VM
apt-get install -y virtualbox virtualbox-guest-additions-iso virtualbox-dkms

apt-get install -y lxc lxc-templates
curl -sSL https://get.docker.com/ubuntu/ | sh
apt-get install -y apparmor
apt-get install -y vagrant ansible

# Fonts
apt-get install -y fonts-droid ttf-mscorefonts-installer

# Keyboard tools
apt-get install -y parcellite

# Remote desktop (optional)
# apt-get install -y xrdp vino
#echo "gnome-session --session=ubuntu-2d" > ~/.xsession

# Term
apt-get install -y terminator

# Charts
apt-get install -y graphviz

# Diff tool
apt-get install -y meld

# Screenshot
apt-get install -y shutter

# Cloud
apt-get install -y dropbox

# Remove packages
apt-get purge -y avahi-daemon

# Fix broken windows on some apps
# gsettings set com.canonical.desktop.interface scrollbar-mode normal

# Enable always show for menus
gsettings set com.canonical.Unity always-show-menus true

apt-get clean

echo "Done."
echo "Suggestions: atom, sublime-text, skype, google-chrome, xmind, yed"
