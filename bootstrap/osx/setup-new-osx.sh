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
sudo chmod 4755 $mtrlocation/sbin/mtr
sudo chown root $mtrlocation/sbin/mtr

# We need cask to start install OSX applications
brew install caskroom/cask/brew-cask

# Editors
brew install ctags \
             vim --override-system-vi \
			 neovim

brew cask install sublime-text

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
brew cask install dropbox

# Torrents
brew cask install transmission

# P2P
brew cask install eiskaltdcpp

# Media
brew cask install vlc

# Mindmap
brew cask install xmind

# Graps
brew cask install yed

# Eyes
brew cask install flux

# Remove outdated versions from the cellar
brew cleanup

cat <<EOT
Suggestions for manual install:
Skype               brew cask install skype
Wunderlist          https://www.wunderlist.com/download/
Pocket              https://getpocket.com/apps/desktop/
MacDjView           http://sourceforge.net/projects/windjview/files/MacDjView/
Popcorn time        https://popcorntime.io/
EOT
