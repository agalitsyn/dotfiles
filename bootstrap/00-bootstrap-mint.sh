#!/bin/sh

set -ex

###
# Linux Mint based in Ubuntu 14.04
###

# Add repos
add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:shutter/ppa
add-apt-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:webupd8team/java

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y make \
                   gcc \
                   software-properties-common

# Essential
apt-get install -y git \
                   gitk \
                   mc \
                   htop \
                   smartmontools Filebrowser
                   rar \
                   unrar \
                   ssh \
                   tree \
                   curl \
                   wget \
                   nfs-common \
                   ack-grep \
                   tmux \
                   screen \
                   traceroute \
                   mtr \
                   gtkvncviewer

# Look
apt-get install -y numix-icon-theme numix-icon-theme-circle numix-gtk-theme

# VM
apt-get install -y virtualbox \
                   virtualbox-dkms \
                   virtualbox-qt \
                   virtualbox-guest-additions-iso

apt-get install -y vagrant ansible
apt-get install -y lxc
curl -sSL https://get.docker.com/ | sh

# Fonts
apt-get install -y fonts-droid \
                   ttf-mscorefonts-installer \
                   xfonts-terminus \
                   console-terminus

# Filebrowser
apt-get install -y ranger \
                   caca-utils \
                   highlight \
                   atool \
                   w3m \
                   w3m-img \
                   poppler-utils \
                   mediainfo
ranger --copy-config=all

# Browser
apt-get install -y firefox

# claws-mail
apt-get install -y claws-mail claws-mail-extra-plugins
# Spellchecker
apt-get install -y hunspell-en-us hunspell-ru

# Keyboard tools
apt-get install -y parcellite xclip

# Screenshot
apt-get install -y shutter

# Term
apt-get install -y terminator

# Charts
apt-get install -y graphviz

# Editors
apt-get install -y vim vim-gtk ctags sublime-text

# Diff tool
apt-get install -y meld

# Storage
apt-get install -y dropbox

# Sound
apt-get install -y pavucontrol

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer \
                   oracle-java8-set-default

# Previent .local handling
apt-get purge -y avahi-daemon

apt-get clean

echo "Done."
echo "Suggestions: xmind, yed, pycharm."
