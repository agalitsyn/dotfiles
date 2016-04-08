#!/bin/sh

set -xe

###
# Debian 8 "Jessie"
# Run after minimal install
###

# Add repos

cat > /etc/apt/sources.list << EOL
deb http://mirror.yandex.ru/debian/ jessie main contrib non-free
deb-src http://mirror.yandex.ru/debian/ jessie main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

deb http://mirror.yandex.ru/debian/ jessie-updates main contrib non-free
deb-src http://mirror.yandex.ru/debian/ jessie-updates main contrib non-free

deb http://ftp.ru.debian.org/debian jessie-backports main

deb http://ftp.ru.debian.org/debian stretch main contrib non-free
EOL

echo 'APT::Default-Release "jessie";' > /etc/apt/apt.conf.d/01defaultrelease
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/02norecommends
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/03disabletranslations

cat > /etc/apt/sources.list.d/webupd8team-java.list << EOL
deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
EOL
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

# Support for multiarch packages. Uncomment, if needed
dpkg --add-architecture i386

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y --no-install-recommends \
                   make \
                   cmake \
                   gcc \
                   software-properties-common

# Essential
apt-get install -y --no-install-recommends \
                   vim \
                   ctags \
                   git \
                   gitk \
                   tig \
                   sudo \
                   htop \
                   iotop \
                   strace \
                   tcpdump \
                   smartmontools \
                   net-tools \
                   ssh \
                   tree \
                   curl \
                   wget \
                   nfs-common \
                   ack-grep \
                   silversearcher-ag \
                   tmux \
                   screen \
                   traceroute \
                   mtr \
                   lshw \
                   ntp \
                   pm-utils \
                   grc \
                   wpasupplicant \
                   pptp-linux \
                   apache2-utils \
                   zsh \
                   p7zip-full \
                   p7zip

# Fun
apt-get install -y --no-install-recommends \
			cowsay \
			fortune \
			figlet
# X & DE
apt-get install -y --no-install-recommends \
                   xorg \
                   slim \
                   i3 \
                   rofi \
                   dunst \
                   lxappearance \
                   feh \
                   numlockx \
                   unclutter \
                   xautolock \
                   xbacklight \
                   xarchiver \
                   fbxkb \
                   dmz-cursor-theme \
                   xcursor-themes

# Fonts
apt-get install -y --no-install-recommends \
                   fonts-droid \
                   fonts-liberation \
                   ttf-mscorefonts-installer \
                   xfonts-terminus

# Sound
apt-get install -y --no-install-recommends \
                   pulseaudio \
                   pavucontrol \
                   pasystray

# VM
apt-get install -y --no-install-recommends \
                   virtualbox \
                   virtualbox-dkms \
                   virtualbox-qt \
                   virtualbox-guest-additions-iso

apt-get install -y --no-install-recommends \
                   vagrant

apt-get install -y --no-install-recommends \
                   lxc
curl -sSL https://get.docker.com/ | sh

# Filebrowser
apt-get install -y --no-install-recommends \
                   pcmanfm

# Mail
apt-get install -y --no-install-recommends \
                   claws-mail \
                   claws-mail-fancy-plugin \
                   claws-mail-multi-notifier \
                   claws-mail-pgpinline \
                   claws-mail-vcalendar-plugin

# Spellchecker
apt-get install -y --no-install-recommends \
                   hunspell-en-us \
                   hunspell-ru

# Keyboard tools
apt-get install -y --no-install-recommends \
                   parcellite \
                   xclip

# Term
apt-get install -y --no-install-recommends \
                   xfce4-terminal

# Charts
apt-get install -y --no-install-recommends \
                   graphviz

# Oracle Java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y --no-install-recommends \
                   oracle-java8-installer \
                   oracle-java8-set-default

# Drivers
apt-get install -t stretch -y --no-install-recommends \
                   firmware-iwlwifi \
                   firmware-linux \
                   firmware-realtek \
                   intel-microcode

# Printer
apt-get install -y --no-install-recommends \
                   cups \
                   printer-driver-foo2zjs \
                   hplip

# Images
apt-get install -y --no-install-recommends \
                   imagemagick \
                   scrot \
                   pandoc

# Office
apt-get install -y --no-install-recommends \
                   libreoffice

apt-get install -y --no-install-recommends \
                    zathura zathura-djvu
# IM
apt-get install -y --no-install-recommends \
                   pidgin

# IM
apt-get install -y --no-install-recommends \
                   meld

apt-get clean

echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf

update-initramfs -t -u

echo "Done."
echo
echo "See https://wiki.debian.org/SSDOptimization"
echo
echo "Suggestions: chrome, dropbox, virtualbox, vagrant, xmind, yed, pycharm."
