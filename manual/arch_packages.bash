#!/bin/bash

# Probably vim, git ane sudo is already installed.

# Ask for the administrator password upfront.
sudo -v 

pacman-key --init
pacman-key --populate archlinux
pacman -Suy

pacman -S --noconfirm bash-completion ntp alsa-utils mlocate
systemctl enable ntpd.service
updatedb
alsamixter --unmute

pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit mesa xorg-twm xorg-xclock xterm xclip xscreensaver numlockx xdm-archlinux
# Need to install video driver 
# lspci | grep VGA
# pacman -Ss xf86-video | less

pacman -S --noconfirm awesome archlinux-wallpapper
pacman -S --noconfirm ttf-droid ttf-dejavu terminus-font ttf-ubuntu-font-family
pacman -S --noconfirm subversion htop tree wget tmux python-setuptools archey3 imagemagick smartmontools unrar fakeroot binutils

pacman -S --noconfirm ranger libcaca highlight atool lynx poppler mediainfo transmission-cli
ranger --copy-config=all

pacman -S --noconfirm chromium firefox
pacman -S --noconfirm claws-mail
pacman -S --noconfirm pcmanfm
pacman -S --noconfirm vlc
pacman -S --noconfirm libreoffice
pacman -S --noconfirm gvfs udisks2

