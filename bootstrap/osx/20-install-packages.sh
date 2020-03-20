#!/bin/bash

set -ex

# homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Additional shells
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
brew install bash \
	bash-completion

# Make it GNU/Linux :)
brew install coreutils \
	moreutils \
	findutils --with-default-names \
	gnu-sed --with-default-names \
	gnutls \
	gnu-tar --with-default-names \
	gawk \
	watch \
	gettext \
	grep --with-default-names \
	git \
	tmux \
	curl \
	telnet \
	wget --enable-iri \
	ag \
	ripgrep \
	tree \
	mc \
	htop-osx \
	netcat \
	mtr \
	z \
	ncdu \
	pv \
	rename

# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

# Fix mtr perms
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//')
sudo chmod 4755 "$mtrlocation/sbin/mtr"
sudo chown root "$mtrlocation/sbin/mtr"

# Editors
brew install vim --with-override-system-vi \
	ctags \
	shellcheck

# cli tools
brew install httpie \
	jq \
    yq

# Add fonts
brew tap caskroom/fonts
brew cask install font-source-code-pro \
	font-fira-code \
	font-hack

# Necessary for CLI on images
brew install imagemagick
brew install ffmpeg --with-libvpx

# You might want there editors:
brew cask install sublime-text
	visual-studio-code \

# Git GUI
brew cask install sourcetree

# Languages
brew cask install java
# better to update ruby, for some tools
brew install ruby
	python \
	pyenv \
    pipenv \
	node \
	yarn --without-node \
	go \
	go-delve/delve/delve

# Add backing services primarily for python builds
brew install postgresql \
 	libmemcached \
 	memcached \
 	redis

# Graphs
brew install graphviz

# Virt
brew cask install virtualbox \
	virtualbox-extension-pack \
	vagrant \
	docker

# CMS
brew install ansible

# Cloud
brew install terraform \
	doctl \
	awscli

# Browsers
brew cask install firefox \
	google-chrome \
	torbrowser

# Terminal
brew cask install iterm2

# Window enhancements
brew cask install spectacle

# External monitor resolution tool
brew cask install avibrazil-rdm

# Clipboard
brew cask install flycut

# Storage
brew cask install dropbox
brew cask install google-backup-and-sync
# brew cask install google-photos-backup-and-sync

# Torrents
brew cask install transmission

# Media
brew cask install vlc
brew install youtube-dl

# Phones
brew cask install android-file-transfer
brew cask install ifunbox

# djview
brew cask install djview

# Help unlucky windows guys
brew cask install teamviewer

# IM
brew cask install slack
brew cask install skype

# NTFS
brew cask install osxfuse
brew install ntfs-3g
#sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
#sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# Cleariness
# brew cask install cleanmymac

# IDE
brew cask install jetbrains-toolbox

# Screenshoting
brew cask install skitch

# P2P
# brew cask install eiskaltdcpp

# Mindmap
brew cask install xmind

# Graphs
brew cask install yed

# Emulator
brew cask install dosbox

# Keyboard
brew cask install karabiner-elements

# Images
# brew cask install \
# 	sketchbook \
# 	gimp \
# 	adobe-photoshop-cc \
# 	adobe-photoshop-lightroom

# Monitoring tools
# brew cask install menumeters \
# 	smcfancontrol
# brew cask install istat-menus

############################
### Not needed on sierra ###
############################

# Save eyes
# brew cask install flux

# Remove outdated versions from the cellar
brew cleanup

