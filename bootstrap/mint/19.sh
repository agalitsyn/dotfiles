#!/usr/bin/env bash
#
# Mint 19

set -xe

apt-get install --yes software-properties-common

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/02norecommends
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/03disabletranslations

cat > /etc/apt/sources.list.d/google-chrome.list << EOL
deb [ arch=amd64 ] http://dl.google.com/linux/chrome/deb/ stable main
EOL
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -

# Support for multiarch packages.
dpkg --add-architecture i386

# Keep newest
apt-get update
apt-get upgrade --yes

# Build tools
apt-get install --yes \
	build-essential \
	cmake \
	dkms \
	linux-headers-generic

# Essential
apt-get install --yes \
	sudo \
	ssh \
	ntp \
	smartmontools \
	openvpn \
	apt-transport-https \
	ca-certificates

# Utils
apt-get install --yes \
    moreutils \
	tree \
	curl \
	wget \
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
	rng-tools \
	net-tools \
    bridge-utils \
    iptables-persistent \
    zsh \
    gnupg-agent

# Debug
apt-get install --yes \
	linux-tools-generic \
	htop \
	iotop \
	strace \
	ltrace \
	tcpdump \
	lsof

# System info
apt-get install --yes \
	lshw \
	inxi

# Networking
apt-get install --yes \
	mtr \
	traceroute \
	nmap \
	arp-scan

# IDE
apt-get install --yes \
	vim \
	neovim \
	ctags \
	git \
	gitk \
	shellcheck \
	xsel \
	sloccount \
	jq \
	httpie

# Editors
apt-get install --yes \
	sublime-text

# Diff
apt-get install --yes \
	meld

# Keyboard tools
apt-get install --yes \
	parcellite

# Charts
apt-get install --yes \
	graphviz

# Filebrowsers
apt-get install --yes \
	mc

# Fonts
apt-get install --yes \
	fonts-liberation \
	ttf-mscorefonts-installer \
	xfonts-terminus \
	ttf-dejavu-extra \
	ttf-dejavu \
	ttf-dejavu-core \
	fonts-hack

# CM
apt-get install --yes \
	ansible

# Spellchecker
apt-get install --yes \
	hunspell-en-us \
	hunspell-ru

# Images
apt-get install --yes \
	imagemagick \
	pandoc

# Fun
apt-get install --yes \
	cowsay \
	fortune \
	figlet

# Golang
apt-get install --yes \
	golang-doc \
	golang-src \
	golang-go \
	golang-race-detector-runtime

# Python
apt-get install --yes \
	python \
	python-dev \
	python3 \
	python3-dev

# Google chrome
apt-get install --yes \
	google-chrome-stable

# Sound
apt-get install --yes \
	pavucontrol

# extfat
apt-get install --yes \
	exfat-utils \
	exfat-fuse

# IM
apt-get install --yes \
	telegram-desktop \
    skypeforlinux

# Docker
if ! docker version > /dev/null 2>&1; then
    curl --silent --show-error --location "https://get.docker.com/" | sh
    usermod -aG docker "$USER"
    newgrp docker
fi

apt-get clean

echo "Done."
