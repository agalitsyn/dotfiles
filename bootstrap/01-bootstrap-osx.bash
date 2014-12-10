#!/usr/bin/env bash

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --default-names

# Install Bash 4
brew install bash bash-completion

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew install homebrew/dupes/screen

brew tap josegonzalez/homebrew-php

# Install everything else
brew install vim --override-system-vi
brew install ack
brew install git
brew install rename
brew install tree
brew install mc
brew install python3
brew install ctags
brew install htop
brew install pwgen
# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

brew install node # This installs `npm` too using the recommended installation method

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

echo '==> Editors'
echo 'Sublime text:'
open http://www.sublimetext.com/3
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

