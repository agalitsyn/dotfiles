#!/bin/bash

set -ex

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Make it GNU/Linux :)
brew tap homebrew/dupes
brew install bash \
             bash-completion \
             zsh \
             coreutils --with-default-names \
             findutils --with-default-names \
             gnu-indent --with-default-names \
             gnu-sed --with-default-names \
             gnutls --with-default-names \
             gnu-tar --with-default-names \
             gawk \
             gettext \
             grep --with-default-names \
             git \
             screen \
             tmux \
             curl \
             wget --enable-iri \
             ack \
             tree \
             mc \
             htop-osx \
             pwgen \
             ssh-copy-id \
             netcat \
             mtr \
             pandoc \
             asciidoc \
             grc \
             ffmpeg --with-libvpx \
             youtube-dl \
             imagemagick \
             ghostscript \
             parallel \
             csshx

# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

# Fix mtr perms
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 "$mtrlocation/sbin/mtr"
sudo chown root "$mtrlocation/sbin/mtr"

# We need cask to start install OSX applications
brew install caskroom/cask/brew-cask

# Editors
brew install ctags \
             vim --override-system-vi \
			 neovim

# Do bash right
brew install shellcheck

brew cask install sublime-text

# You might want there slow chromium-based editors:
#brew cask install atom \
				  #visual-studio-code

# Git GUI
brew cask install sourcetree

# Languages
brew install python3 \
             node \
			 ruby \
             go

# Graphs
brew install graphviz

# Virt
brew cask install virtualbox \
                  virtualbox-extension-pack \
                  vagrant \
				  docker

# CM
brew install ansible

# Browsers
brew cask install firefox \
                  google-chrome \
				  torbrowser

# Terminal
brew cask install iterm2

# Window enhancements
brew cask install spectacle

# Keyboard
brew cask install seil \
                  karabiner

# Clipboard
brew cask install flycut

# Monitoring tools
brew cask install menumeters \
                  smcfancontrol

# IDE
brew cask install pycharm-ce

# Storage
brew cask install dropbox \
				  google-drive

# Torrents
brew cask install transmission

# P2P
#brew cask install eiskaltdcpp

# Media
brew cask install vlc

# Mindmap
brew cask install xmind

# Graphs
brew cask install yed

# Save eyes
brew cask install flux

# Cleariness
brew cask install cleanmymac

# Phones
brew cask install android-file-transfer \
				  ifunbox

# Old days
brew cask install dosbox

# djview
brew cask install djview

# IM
brew cask install skype \
				  slack

# Screenshoting
brew cask install skitch

# Help unlucky windows guys
brew cask install teamviewer

# Images
#brew cask install \
	#sketchbook \
	#gimp \
	#adobe-photoshop-cc \
	#adobe-photoshop-lightroom

# Remove outdated versions from the cellar
brew cleanup

cat <<EOT
Suggestions for manual install:
Pocket              https://getpocket.com/apps/desktop/
MacDjView           http://sourceforge.net/projects/windjview/files/MacDjView/
Popcorn time        https://popcorntime.io/
EOT
