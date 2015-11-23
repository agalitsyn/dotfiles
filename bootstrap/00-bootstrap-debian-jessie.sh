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

cat > /etc/apt/apt.conf.d/02defaultrelease << EOL
APT::Default-Release "jessie";
EOL

cat > /etc/apt/sources.list.d/webupd8team-java.list << EOL
deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
EOL
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

# Support for multiarch packages. Uncomment, if needed
#dpkg --add-architecture i386

# Keep newest
apt-get update
apt-get upgrade -y

# Build tools
apt-get install -y make \
                   cmake \
                   gcc \
                   software-properties-common

# Essential
apt-get install -y vim \
                   ctags \
                   git \
                   gitk \
                   tig \
                   mc \
                   htop \
                   iotop \
                   strace \
                   tcpdump \
                   smartmontools \
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
                   lshw \
                   pm-utils \
                   grc \
                   wpasupplicant

# X & DE
apt-get install -y xorg \
                   slim \
                   i3 \
                   sudo \
                   lxappearance \
                   feh \
                   numlockx \
                   unclutter \
                   xautolock \
                   xbacklight

# Fonts
apt-get install -y fonts-droid \
                   fonts-liberation \
                   ttf-mscorefonts-installer \
                   xfonts-terminus

# Sound
apt-get install -y pulseaudio \
                   pavucontrol \
                   pasystray

# VM
apt-get install -y virtualbox \
                   virtualbox-dkms \
                   virtualbox-qt \
                   virtualbox-guest-additions-iso

apt-get install -y vagrant

apt-get install -y lxc
curl -sSL https://get.docker.com/ | sh

# Filebrowser
apt-get install -y pcmanfm

# Mail
apt-get install -y claws-mail \
                   claws-mail-fancy-plugin

# Spellchecker
apt-get install -y hunspell-en-us hunspell-ru

# Keyboard tools
apt-get install -y parcellite xclip

# Term
apt-get install -y xfce4-terminal

# Charts
apt-get install -y graphviz

# Oracle Java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer \
                   oracle-java8-set-default

# Drivers
apt-get install -y firmware-iwlwifi \
                   firmware-linux-free \
                   firmware-linux-nonfree \
                   firmware-realtek \
                   intel-microcode

# Printer
apt-get install -y cups \
                   printer-driver-foo2zjs \
                   hplip

# Images
apt-get install -y imagemagick \
                   scrot


apt-get clean

echo "Done."
echo
echo "See https://wiki.debian.org/SSDOptimization"
echo
echo "Suggestions: chrome, dropbox, virtualbox, vagrant, xmind, yed, pycharm."
