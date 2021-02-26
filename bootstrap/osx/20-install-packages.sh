#!/bin/bash

set -ex

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Additional shells
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
brew install bash \
    bash-completion \
    zsh \
    zsh-completions

# Make it GNU/Linux :)
brew install coreutils \
    moreutils \
    findutils \
    gnu-sed \
    gnutls \
    gnu-tar \
    gawk \
    watch \
    gettext \
    grep \
    git \
    tmux \
    curl \
    telnet \
    wget \
    tree \
    mc \
    netcat \
    pv

# cli editor
brew install vim \
    ctags \
    shellcheck

# New cli tools
brew install httpie \
    jq \
    yq \
    exa \
    bat \
    ripgrep \
    z \
    pgcli \
    git-delta

# Add fonts
brew tap homebrew/cask-fonts
brew cask install \
    font-source-code-pro \
    font-fira-code \
    font-hack \
    font-jetbrains-mono \
    font-cascadia-code

# Necessary for CLI on images
brew install imagemagick

# You might want there editors:
brew cask install \
    sublime-text \
    visual-studio-code

# Git GUI
brew cask install sublime-merge

# Languages
brew install \
    python \
    pyenv \
    pipenv \
    node \
    yarn \
    go

# Add backing services primarily for python builds
brew install \
    postgresql \
    libmemcached \
    memcached \
    redis

# Graphs
brew install graphviz

# Virt
#brew cask install virtualbox \
#    virtualbox-extension-pack \
#    vagrant

# Containers
brew cask install docker

# CMS
brew install ansible

# Cloud
#brew install terraform \
#    doctl \
#    awscli

# Browsers
brew cask install firefox \
    google-chrome

# Terminal
brew cask install iterm2

# Window enhancements
brew cask install spectacle
#brew cask install rectangle

# External monitor resolution tool
brew cask install avibrazil-rdm

# sync ext monitor brightness
#brew cask install brisync

# Clipboard
brew cask install maccy

# Storage
brew cask install google-backup-and-sync
brew cask install yandex-disk
# brew cask install dropbox
# brew cask install google-photos-backup-and-sync

# Torrents
brew cask install transmission

# Media
brew cask install vlc
brew install youtube-dl

# Phones
brew cask install android-file-transfer
#brew cask install ifunbox

# djview
brew cask install djview

# Help unlucky windows guys
#brew cask install teamviewer

# IM (choose what your need)
brew cask install slack
brew cask install skype
brew cask install zoom
brew cask install telegram
brew cask install discord
brew cask install whatsapp

# Avoid rkn
brew cask install cloudflare-warp
brew cask install protonvpn

# NTFS
# This driver is slow, writig speed 20x slower than on appfs. Better to use paragon ntfs.
#brew cask install osxfuse
#brew install ntfs-3g
#sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
#sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# Cleaner
# brew cask install cleanmymac

# Tray improvements
brew cask install itsycal

# Controls sleep
#brew cask install caffeine

# os theme switcher
#brew cask install nightowl

# Control GPUs
#brew cask install gswitch

# Monitor temp
brew cask install fanny

# Screen recording
#brew cask install kap
#brew install asciinema

# IDE
#brew cask install jetbrains-toolbox

# Screenshoting
#brew cask install skitch

# Mindmap
brew cask install xmind

# Graphs
#brew cask install yed

# Emulator
#brew cask install dosbox

# Manage ebooks
brew cask install calibre

# Keyboard
brew cask install karabiner-elements

# Images
# brew cask install \
#   sketchbook \
#   adobe-photoshop-cc \
#   adobe-photoshop-lightroom

# Remove outdated versions from the cellar
brew cleanup

