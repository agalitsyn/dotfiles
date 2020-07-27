#!/usr/bin/env bash
#
# Mint 19

set -xe

apt-get install --yes --no-install-recommends \
    software-properties-common \
    apt-transport-https

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/02norecommends
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/03disabletranslations

cat > /etc/apt/sources.list.d/google-chrome.list << EOL
deb [ arch=amd64 ] http://dl.google.com/linux/chrome/deb/ stable main
EOL
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" > /etc/apt/sources.list.d/yandex-disk.list
wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | apt-key add -
add-apt-repository -y ppa:slytomcat/ppa

add-apt-repository -y ppa:numix/ppa
add-apt-repository -y ppa:webupd8team/java
apt-add-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:rmescandon/yq

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
    gnupg-agent \
    hibernate \
    acpitool

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
    yq \
    httpie \
    ripgrep \
    bat \
    fd-find

#update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
#update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
#update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

# Editors
apt-get install --yes --no-install-recommends \
    sublime-text \
    code

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

# i3 DE
apt-get install --yes --no-install-recommends \
    xorg \
    slim \
    lightdm-gtk-greeter-settings \
    i3-wm \
    i3status \
    i3lock \
    xautolock \
    xscreensaver \
    xscreensaver-gl-extra \
    xscreensaver-data-extra \
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
    mpd \
    rxvt-unicode

# Night work
apt-get install --yes --no-install-recommends \
    redshift

# Themes
apt-get install --yes --no-install-recommends \
    xcursor-themes \
    dmz-cursor-theme \
    arc-theme \
    murrine-themes \
    gtk2-engines-murrine:i386 \
    gtk2-engines-pixbuf:i386 \
	numix-gtk-theme \
	numix-icon-theme-circle

# Fonts
apt-get install --yes --no-install-recommends \
    fonts-liberation \
    ttf-mscorefonts-installer \
    xfonts-terminus \
    ttf-dejavu-extra \
    ttf-dejavu \
    ttf-dejavu-core \
    fonts-hack

FONTS_HOME=~/.local/share/fonts
mkdir -p "$FONTS_HOME/adobe-fonts"

(git clone \
   --branch release \
   --depth 1 \
   'https://github.com/adobe-fonts/source-code-pro.git' \
   "$FONTS_HOME/adobe-fonts/source-code-pro" && \
fc-cache -f -v "$FONTS_HOME/adobe-fonts/source-code-pro")

# Wine
apt-get install --yes --no-install-recommends \
    wine-stable \
    wine32 \
    winetricks

# VM
apt-get install --yes --no-install-recommends \
    virtualbox \
    virtualbox-dkms \
    virtualbox-qt \
    virtualbox-guest-additions-iso

apt-get install --yes --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    libvirt-bin \
    dnsmasq \
    dnsutils \
    ebtables

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

# Image editors
apt-get install -y --no-install-recommends \
	gimp
	#krita

# Screenshoots
apt-get install --yes --no-install-recommends \
    shutter \
    scrot

# Video
apt-get install --yes --no-install-recommends \
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

# Fun
apt-get install --yes --no-install-recommends \
    cowsay \
    fortune \
    figlet

# Oracle Java 8
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install --yes \
    oracle-java8-installer \
    oracle-java8-set-default

# Python
apt-get install --yes --no-install-recommends \
    python \
    python-dev \
    python3 \
    python3-dev

# Dev libs (for pip packages)
apt-get install --yes --no-install-recommends \
    libpq-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev

# Office
apt-get install --yes --no-install-recommends \
    libreoffice

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

apt-get install --yes --no-install-recommends \
    yandex-disk \
    yd-tools

# Partition tools
apt-get install --yes --no-install-recommends \
    gparted

# Torrent
apt-get install --yes --no-install-recommends \
	transmission

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
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    apt-get install -y nodejs

    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    apt-get update
    apt-get install yarn
fi

apt-get clean

echo "Done."
