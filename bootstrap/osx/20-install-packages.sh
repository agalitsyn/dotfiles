#!/bin/bash

set -ex

# homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Make it GNU/Linux :)
brew install bash \
	bash-completion \
	coreutils --with-default-names \
	findutils --with-default-names \
	gnu-sed --with-default-names \
	gnutls --with-default-names \
	gnu-tar --with-default-names \
	gawk \
	watch \
	gettext \
	grep --with-default-names \
	git \
	tmux \
	curl \
	wget --enable-iri \
	ag \
	tree \
	mc \
	htop-osx \
	netcat \
	mtr

# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

# Fix mtr perms
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//')
sudo chmod 4755 "$mtrlocation/sbin/mtr"
sudo chown root "$mtrlocation/sbin/mtr"

# We need cask to start install OSX applications
# brew install caskroom/cask/brew-cask

# Additional shells
brew install zsh

# Editors
brew install ctags \
	vim --override-system-vi

# Do bash right
brew install shellcheck

# Handle rest services
brew install httpie jq

# Add fonts
brew tap caskroom/fonts
brew cask install font-source-code-pro \
	font-fira-code \
	font-hack

# You might want there editors:
brew cask install visual-studio-code \
	sublime-text

# Git GUI
brew cask install sourcetree

# Languages
brew cask install java
brew install python \
	python3 \
	pyenv \
	node \
	ruby \
	go \
	scala \
	sbt \
	maven \
	gradle

# Backing services and libs
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

# CM
brew install ansible \
	saltstack

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

# Clipboard
brew cask install flycut

# IDE
brew cask install pycharm-ce \
	intellij-idea-ce

# Storage
# google-drive was deleted for some reason
brew cask install dropbox

# Torrents
brew cask install transmission

# Media
brew cask install vlc

# Cleariness
brew cask install cleanmymac

# Phones
brew cask install android-file-transfer
# brew cask install ifunbox

# djview
brew cask install djview

# Help unlucky windows guys
brew cask install teamviewer

# IM
brew cask install skype \
	slack

# Screenshoting
# brew cask install skitch

# P2P
# brew cask install eiskaltdcpp

# Mindmap
# brew cask install xmind

# Graphs
# brew cask install yed

# Not needed on sierra

# Save eyes
# brew cask install flux

# Window enhancements (not needed on sierra)
# brew cask install spectacle

# Keyboard
# brew cask install seil \
# 	karabiner

# Monitoring tools
# brew cask install menumeters \
# 	smcfancontrol

# Old days
# brew cask install dosbox

# Images
# brew cask install \
# 	sketchbook \
# 	gimp \
# 	adobe-photoshop-cc \
# 	adobe-photoshop-lightroom

# Remove outdated versions from the cellar
brew cleanup