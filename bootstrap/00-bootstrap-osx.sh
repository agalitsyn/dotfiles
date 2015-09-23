#!/bin/sh

set -ex

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# Export brew stuff
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_extra

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Make it GNU/Linux :)
brew tap homebrew/dupes
brew install bash \
             bash-completion \
             zsh \
             coreutils \
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
             rename \
             tree \
             mc \
             htop-osx \
             pwgen \
             ssh-copy-id \
             netcat \
             pandoc \
             asciidoc
# Fixes
echo 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.bash_extra
echo 'export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"' >> ~/.bash_extra
echo 'export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"' >> ~/.bash_extra
echo 'export MANPATH="$(brew --prefix gnu-sed)/libexec/gnuman:$MANPATH"' >> ~/.bash_extra
# Fix htop permissions
find /usr/local/Cellar/ -name htop -exec chmod 6555 {} \; -exec sudo chown root {} \;

# We need cask to start install OSX applications
brew install caskroom/cask/brew-cask

# Editors
brew install ctags \
             vim --override-system-vi
brew cask install sublime-text

# Languages
brew install python3 \
             node \
             go
# Fixes
echo 'export PATH="$(brew --prefix go)/libexec/bin:$PATH"' >> ~/.bash_extra

# VM
brew cask install virtualbox \
                  virtualbox-extension-pack \
                  vagrant
# echo 'export PATH="/Applications/Vagrant/bin:$PATH"' >> ~/.bash_extra
brew install ansible \
             boot2docker

# Fonts
brew tap caskroom/fonts
brew cask install font-terminus

# Browsers
brew cask install firefox \
                  google-chrome

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
brew cask install pycharm

# Storage
brew cask install dropbox

# Torrents
brew cask install transmission

# P2P
brew cask install eiskaltdcpp

# Media
brew cask install vlc

# Productivivty
brew cask install evernote

# Mindmap
brew cask install xmind

# Graps
brew cask install graphviz \
                  yed

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
