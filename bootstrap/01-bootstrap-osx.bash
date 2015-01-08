#!/usr/bin/env bash

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# Export brew stuff
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_extra

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.bash_extra
echo 'export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"' >> ~/.bash_extra

# Install other GNU utils
brew install findutils --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-sed --with-default-names
echo 'export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"' >> ~/.bash_extra
echo 'export MANPATH="$(brew --prefix gnu-sed)/libexec/gnuman:$MANPATH"' >> ~/.bash_extra
brew install gnutls --with-default-names
brew install gnu-tar --with-default-names
brew install gawk

brew tap homebrew/dupes
brew install grep --with-default-names
brew install screen

# Install Bash 4
brew install bash bash-completion

# Install wget with IRI support
brew install wget --enable-iri

# Install everything else
brew install git
brew install vim --override-system-vi
brew install ctags
brew install ack
brew install rename
brew install tree
brew install mc
brew install htop-osx
brew install pwgen

# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

# dev
brew install python3
brew install node # This installs `npm` too using the recommended installation method
brew install go
echo 'export PATH="$(brew --prefix go)/libexec/bin:$PATH"' >> ~/.bash_extra
brew install lua
brew tap josegonzalez/homebrew-php
brew install php56

# devops
brew install netcat
brew install ansible
brew install boot2docker

#brew install tor

# Remove outdated versions from the cellar
brew cleanup

echo 'Manually install apps:'

echo '==> Terminal'
echo 'Iterm 2:'
open https://iterm2.com/downloads.html

echo '==> Keyboard'
echo 'Spectacle:'
open http://spectacleapp.com/
echo 'Flycut:'
open https://itunes.apple.com/ru/app/flycut-clipboard-manager/id442160987?mt=12
echo 'Seil (Keyboard hacks)'
open https://pqrs.org/osx/karabiner/seil.html.en

echo '==> Monitoring tools'
echo 'Menu meters'
open http://www.ragingmenace.com/software/menumeters/#download

echo '==> Browsers'
echo 'Firefox:'
open http://www.mozilla.org/en-US/firefox/new/
echo 'Chrome:'
open https://www.google.com/intl/en/chrome/browser/
echo 'Tor browser'
open https://www.torproject.org/download/download-easy.html.en

echo '==> Editors'
echo 'Sublime text:'
open http://www.sublimetext.com/3
echo 'Atom'
open https://atom.io/
echo 'Pycharm'
open https://www.jetbrains.com/pycharm/download

echo '==> Cloud data storages'
echo 'Dropbox:'
open https://www.dropbox.com

echo '==> Messaging'
echo 'Skype:'
open http://www.skype.com/en/download-skype/skype-for-computer/
echo 'Hipchat:'
open https://www.hipchat.com/downloads

echo '==> Torrents'
echo 'Transmission:'
open http://www.transmissionbt.com

echo '==> Media'
echo 'VLC:'
open http://www.videolan.org/vlc/index.html
echo 'Popcorn time'
open https://popcorntime.io/

echo '==> Virtualization'
echo 'Virtualbox and extensions:'
open https://www.virtualbox.org/wiki/Downloads
echo 'Vagrant:'
open https://www.vagrantup.com/downloads
echo 'Execute: echo export PATH="/Applications/Vagrant/bin:$PATH" >> ~/.bash_extra'

echo '==> Readers'
echo 'MacDjView'
open http://sourceforge.net/projects/windjview/files/MacDjView/

echo '==> Productivivty'
echo 'Evernote'
open https://evernote.com/download/get.php?file=EvernoteMac
echo 'Xmind'
open http://www.xmind.net/download/mac/
echo 'yEd'
open https://www.yworks.com/en/products_yed_download.html
