#!/bin/sh

set -x

###
# Linux Mint based in Ubuntu 14.04
###

# Add repos
add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:shutter/ppa
apt-add-repository -y ppa:ansible/ansible

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y make \
                   gcc \
                   software-properties-common

# Essential
apt-get install -y subversion \
                   git \
                   gitk \
                   vim \
                   vim-gtk \
                   ctags \
                   mc \
                   htop \
                   smartmontools \
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
apt-get install -y apparmor lxc
curl -sSL https://get.docker.com/ubuntu/ | sh

# Fonts
apt-get install -y fonts-droid \
                   ttf-mscorefonts-installer \
                   xfonts-terminus \
                   console-terminus

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

# Cloud
apt-get install -y dropbox

# Remove packages
apt-get purge -y avahi-daemon

echo "Done."
echo "Suggestions: xmind, yed, pycharm."

