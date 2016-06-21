#!/usr/bin/env bash

set -xe

###
# Debian 8 "Jessie"
# Run after minimal install
###

# Clean repos
rm -f /var/lib/apt/list/*

# Add repos
cat > /etc/apt/sources.list << EOL
deb http://httpredir.debian.org/debian/ jessie main contrib non-free
deb http://httpredir.debian.org/debian/ jessie-updates main contrib non-free
deb http://httpredir.debian.org/debian/ jessie-backports main contrib non-free
deb http://security.debian.org/ jessie/updates main contrib non-free
EOL

echo 'APT::Default-Release "jessie";' > /etc/apt/apt.conf.d/01defaultrelease
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/02norecommends
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/03disabletranslations

cat > /etc/apt/sources.list.d/webupd8team-java.list << EOL
deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
EOL

cat > /etc/apt/sources.list.d/google-chrome << EOL
deb [ arch=amd64 ] http://dl.google.com/linux/chrome/deb/ stable main
EOL

cat > /etc/apt/sources.list.d/ubuntu-vivid.list << EOL
deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu vivid main
EOL
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 55F96FCF8231B6DD

# Support for multiarch packages.
dpkg --add-architecture i386

# Peer to peer
echo 'nf_conntrack_pptp' > /etc/modules

# Disable pc speaker
echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf

# Keep newest
apt-get update
apt-get upgrade --yes

# Drop packages
apt-get autoremove --purge --yes \
	avahi-daemon	

# Build tools
apt-get install -y --no-install-recommends \
	build-essential \
	cmake \
	software-properties-common \
	dkms \
	linux-headers-amd64 \
	linux-image-amd64

# Essential
apt-get install -y --no-install-recommends \
	sudo \
	wpasupplicant \
	wavemon \
    wireless-tools \
	pptp-linux \
	powermgmt-base \
	pm-utils \
	ssh \
	ntp \
	debconf \
	debconf-utils \
	apt-transport-https \
	manpages-dev \
	smartmontools \
	net-tools

# Utils
apt-get install -y --no-install-recommends \
	tree \
	curl \
	wget \
	ack-grep \
	silversearcher-ag \
	tmux \
	grc \
	apache2-utils \
	p7zip-full \
	p7zip-rar \
	pbzip2 \
	lzop \
	gettext \
	pwgen

# Debug
apt-get install -y --no-install-recommends \
	linux-tools \
	htop \
	iotop \
	strace \
	ltrace \
	tcpdump \
	lshw \
	lsof \
	mtr \
	traceroute

# IDE
apt-get install -y --no-install-recommends \
	neovim \
	ctags \
	git \
	gitk

# Diff
apt-get install -y --no-install-recommends \
	meld

# Keyboard tools
apt-get install -y --no-install-recommends \
	parcellite

# Term
apt-get install -y --no-install-recommends \
	xfce4-terminal

# Charts
apt-get install -y --no-install-recommends \
	graphviz

# Filebrowser
apt-get install -y --no-install-recommends \
	pcmanfm \
	mc

# X & DE
apt-get install -y --no-install-recommends \
	xorg \
	slim \
	i3-wm \
	i3status \
	i3lock \
	dunst \
	suckless-tools \
	lxappearance \
	feh \
	numlockx \
	unclutter \
	xautolock \
	xbacklight \
	xarchiver \
	fbxkb \
	murrine-themes \
	dmz-cursor-theme \
	xcursor-themes \
	redshift

	#rofi

# Fonts
apt-get install -y --no-install-recommends \
	fonts-droid \
	fonts-liberation \
	ttf-mscorefonts-installer \
	xfonts-terminus \
	ttf-dejavu-extra \
	ttf-dejavu \
	ttf-dejavu-core

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
	libreoffice \
	zathura \
	zathura-djvu

# IM
apt-get install -y --no-install-recommends \
	pidgin

# Media
apt-get install -y --no-install-recommends \
	vlc

# Fun
apt-get install -y --no-install-recommends \
	cowsay \
	fortune \
	figlet

# Oracle Java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y --force-yes --no-install-recommends \
	oracle-java8-installer \
	oracle-java8-set-default

# Drivers
apt-get install -y --no-install-recommends \
	firmware-linux-free \
	firmware-linux-nonfree \
	firmware-iwlwifi \
	firmware-linux \
	firmware-realtek \
	intel-microcode

# Python
apt-get install -y --no-install-recommends \
	python \
	python-dev \
	python3 \
	python3-dev

# Nodejs
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs

# Docker
if ! docker version > /dev/null 2>&1; then
	curl --silent --show-error --location "https://get.docker.com/" | sh
fi

# Google chrome
apt-get install --yes --force-yes --no-install-recommends google-chrome-stable

# Non-repo pkgs
if ! dpkg -s vagrant; then
    wget -O /tmp/vagrant.deb https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb && \
        dpkg -i /tmp/vagrant.deb && \
        apt-get install -f && \
        rm /tmp/vagrant.deb
fi

if ! dpkg -s skype; then
    wget -O /tmp/skype.deb http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb && \
        dpkg -i /tmp/skype.deb && \
        apt-get install -f && \
        rm /tmp/skype.deb
fi

if ! dpkg -s slack-desktop; then
    wget -O /tmp/slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.0.6-amd64.deb && \
        dpkg -i /tmp/slack.deb && \
        apt-get install -f && \
        rm /tmp/slack.deb
fi

# From source
export GCRYPTVER=0.5.0
wget https://www.agwa.name/projects/git-crypt/downloads/git-crypt-${GCRYPTVER}.tar.gz \
    && tar xf git-crypt-${GCRYPTVER}.tar.gz \
    && ( cd git-crypt-${GCRYPTVER} \
    && make \
    && make install PREFIX=${HOME} ) \
    && rm -r git-crypt-${GCRYPTVER}* \

apt-get clean

update-initramfs -t -u

echo "Done."
echo
echo
echo "Suggestions: dropbox, xmind, yed, pycharm."
