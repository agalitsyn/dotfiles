#!/usr/bin/env bash

set -xe

###
# Ubuntu 16.04
###

apt-get install -y --no-install-recommends software-properties-common

add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:shutter/ppa
apt-add-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:neovim-ppa/unstable
add-apt-repository -y ppa:videolan/stable-daily
add-apt-repository ppa:longsleep/golang-backports

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/02norecommends
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/03disabletranslations

cat > /etc/apt/sources.list.d/google-chrome.list << EOL
deb [ arch=amd64 ] http://dl.google.com/linux/chrome/deb/ stable main
EOL

# Support for multiarch packages.
dpkg --add-architecture i386

# Keep newest
apt-get update
apt-get upgrade -y --no-install-recommends

# Drop packages
apt-get autoremove --purge -y \
	avahi-daemon

# Build tools
apt-get install -y --no-install-recommends \
	build-essential \
	cmake \
	dkms \
	linux-headers-generic

# Essential
apt-get install -y --no-install-recommends \
	sudo \
	ssh \
	ntp \
	smartmontools \
	openvpn \
	apt-transport-https \
	ca-certificates

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
	unzip \
	p7zip-full \
	p7zip-rar \
	pbzip2 \
	unrar \
	lzop \
	gettext \
	pwgen \
	rng-tools

# Debug
apt-get install -y --no-install-recommends \
	linux-tools-generic \
	htop \
	iotop \
	strace \
	ltrace \
	tcpdump \
	lsof

# System info
apt-get install -y --no-install-recommends \
	lshw \
	inxi

# Networking
apt-get install -y --no-install-recommends \
	mtr \
	traceroute \
	nmap \
	arp-scan

# IDE
apt-get install -y --no-install-recommends \
	vim \
	neovim \
	ctags \
	git \
	gitk \
	shellcheck \
	wrk \
	xsel \
	sloccount

#update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
#update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
#update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

# Diff
apt-get install -y --no-install-recommends \
	meld

# Keyboard tools
apt-get install -y --no-install-recommends \
	parcellite

# Term
apt-get install -y --no-install-recommends \
	terminator

# Charts
apt-get install -y --no-install-recommends \
	graphviz

# Filebrowser
apt-get install -y --no-install-recommends \
	mc

# X & DE
apt-get install -y --no-install-recommends \
	murrine-themes \
	numix-gtk-theme \
	numix-icon-theme-circle \
	gtk2-engines-murrine:i386 \
	gtk2-engines-pixbuf:i386

# Save your eyes
apt-get install -y --no-Install-recommends \
	redshift \
	redshift-gtk \
	geoclue-2.0

# Ubuntu tweakers
apt-get install -y --no-install-recommends \
	unity-tweak-tool \
	dconf-editor \
	gnome-tweak-tool
# Compiz tweaks: compizconfig-settings-manager compiz-plugins compiz-plugins-extra
# Optional optimizers: preload bum

# Fonts
apt-get install -y --no-install-recommends \
	fonts-liberation \
	ttf-mscorefonts-installer \
	xfonts-terminus \
	ttf-dejavu-extra \
	ttf-dejavu \
	ttf-dejavu-core

# VM
apt-get install -y --no-install-recommends \
	virtualbox \
	virtualbox-dkms \
	virtualbox-qt \
	virtualbox-guest-additions-iso

apt-get install -y --no-install-recommends \
	qemu-system-x86 \
	qemu-utils \
	libvirt-bin \
	dnsmasq \
	dnsutils \
	ebtables

# CM
apt-get install -y --no-install-recommends \
	ansible

# Spellchecker
apt-get install -y --no-install-recommends \
	hunspell-en-us \
	hunspell-ru

# Images
apt-get install -y --no-install-recommends \
	imagemagick \
	pandoc \
	shutter \
	libgoo-canvas-perl

# Media editors
#apt-get install -y --no-install-recommends \
	#gimp \
	#krita

# Video
apt-get install -y --no-install-recommends \
	mesa-utils \
	vainfo \
	vlc \
	browser-plugin-vlc \
	libavcodec-extra \
	ffmpeg \
	x264 \
	libvdpau-va-gl1 \
	vdpauinfo \
	i965-va-driver

# Torrent
apt-get install -y --no-install-recommends \
	transmission

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

# DBs
apt-get install -y --no-install-recommends \
	postgresql \
	postgresql-client \
	sqlite3

# Dev libs (for pip packages)
apt-get install -y --no-install-recommends \
	libpq-dev \
	libssl-dev \
	libjpeg-dev \
	zlib1g-dev

# Golang
apt-get install -y --no-install-recommends golang-go

# Python
apt-get install -y --no-install-recommends \
	python \
	python-dev \
	python3 \
	python3-dev

# Nodejs
if ! npm version > /dev/null 2>&1; then
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	apt-get install -y nodejs
fi

# Docker
if ! docker version > /dev/null 2>&1; then
	curl --silent --show-error --location "https://get.docker.com/" | sh
fi

# Google chrome
apt-get install -y --force-yes --no-install-recommends google-chrome-stable

apt-get clean

# Fix broken windows on some apps
# gsettings set com.canonical.desktop.interface scrollbar-mode normal

# Enable always show for menus
#gsettings set com.canonical.Unity always-show-menus true

echo "Done."
echo "Suggestions: atom, yed"
