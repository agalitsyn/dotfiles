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
apt-get install --yes --no-install-recommends \
    build-essential \
    cmake \
    dkms \
    linux-headers-generic

# Essential
apt-get install --yes --no-install-recommends \
    sudo \
    ssh \
    ntp \
    smartmontools \
    openvpn \
    apt-transport-https \
    ca-certificates

# Utils
apt-get install --yes --no-install-recommends \
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
apt-get install --yes --no-install-recommends \
    linux-tools-generic \
    htop \
    iotop \
    strace \
    ltrace \
    tcpdump \
    lsof

# System info
apt-get install --yes --no-install-recommends \
    lshw \
    inxi

# Networking
apt-get install --yes --no-install-recommends \
    mtr \
    traceroute \
    nmap \
    arp-scan

# IDE
apt-get install --yes --no-install-recommends \
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
apt-get install --yes --no-install-recommends \
    sublime-text

# Diff
apt-get install --yes --no-install-recommends \
    meld

# Keyboard tools
apt-get install --yes --no-install-recommends \
    parcellite

# Charts
apt-get install --yes --no-install-recommends \
    graphviz

# Filebrowsers
apt-get install --yes --no-install-recommends \
    mc \
    ranger atool caca-utils w3m w3m-img highlight python-chardet

# i3 env
apt-get install -y --no-install-recommends \
    xorg \
    slim \
    lightdm-gtk-greeter-settings \
    i3-wm \
    i3status \
    i3lock \
    xautolock \
    xscreensaver \
    dunst \
    rofi \
    suckless-tools \
    lxappearance \
    feh \
    numlockx \
    unclutter \
    xdotool \
    xkbset \
    xbacklight \
    xarchiver \
    arandr \
    xclip \
    xsel \
    gxkb \
    pasystray \
    blueman \
    usbmount \
    pcmanfm \
    rxvt-unicode \
    nitrogen \
    mpd

# Night work
apt-get install -y --no-install-recommends \
    redshift

# Themes
apt-get install -y --no-install-recommends \
    xcursor-themes \
    dmz-cursor-theme \
    arc-theme \
    murrine-themes \
    gtk2-engines-murrine:i386 \
    gtk2-engines-pixbuf:i386

# Fonts
apt-get install --yes --no-install-recommends \
    fonts-liberation \
    ttf-mscorefonts-installer \
    xfonts-terminus \
    ttf-dejavu-extra \
    ttf-dejavu \
    ttf-dejavu-core \
    fonts-hack

# CM
apt-get install --yes --no-install-recommends \
    ansible

# Spellchecker
apt-get install --yes --no-install-recommends \
    hunspell-en-us \
    hunspell-ru

# Images
apt-get install --yes --no-install-recommends \
    imagemagick \
    pandoc

# Screenshoots
apt-get install --yes --no-install-recommends \
    shutter \
    scrot

# Fun
apt-get install --yes --no-install-recommends \
    cowsay \
    fortune \
    figlet

# Golang
apt-get install --yes --no-install-recommends \
    golang-doc \
    golang-src \
    golang-go \
    golang-race-detector-runtime

# Python
apt-get install --yes --no-install-recommends \
    python \
    python-dev \
    python3 \
    python3-dev

# Google chrome
apt-get install --yes --no-install-recommends \
    google-chrome-stable

# Sound
apt-get install --yes --no-install-recommends \
    pavucontrol

# extfat
apt-get install --yes --no-install-recommends \
    exfat-utils \
    exfat-fuse

# IM
apt-get install --yes --no-install-recommends \
    telegram-desktop \
    skypeforlinux

# Webcam
apt-get install --yes --no-install-recommends \
    guvcview

# Docker
if ! docker version > /dev/null 2>&1; then
    curl --silent --show-error --location "https://get.docker.com/" | sh

    curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    curl -L https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
fi
usermod -aG docker "$USER"
newgrp docker

# Nodejs
if ! npm version > /dev/null 2>&1; then
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    apt-get install -y nodejs

    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    apt-get update
    apt-get install yarn
fi

apt-get clean

echo "Done."
