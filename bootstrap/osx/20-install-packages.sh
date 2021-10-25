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
    git-delta \
    tig \
    lazygit \
    xh

# Add fonts
brew tap homebrew/cask-fonts
brew install --cask \
    font-source-code-pro \
    font-fira-code \
    font-hack \
    font-jetbrains-mono \
    font-cascadia-code \
    font-input

# Necessary for CLI on images
brew install imagemagick

# You might want there editors:
brew install --cask \
    sublime-text \
    visual-studio-code

# Git GUI
brew install --cask sublime-merge

# Languages
brew install \
    python \
    pyenv \
    poetry \
    node \
    yarn \
    go

# Add backing services primarily for python builds
brew install \
    postgresql \
    libmemcached \
    memcached \
    redis

# Finder quicklook plugins
brew install --cask WebPQuickLook

# Graphs
brew install graphviz

# Virt
#brew install --cask virtualbox \
#    virtualbox-extension-pack \
#    vagrant

# Containers
brew install --cask docker
brew install lazydocker
brew install ctop

# Ops
brew install ansible \
    terraform \
    doctl \
    awscli

# Browsers
brew install --cask firefox \
    google-chrome

# Terminal
brew install --cask iterm2

# Window enhancements
brew install --cask spectacle
#brew install --cask rectangle

# External monitor resolution tool
brew install --cask avibrazil-rdm

# sync ext monitor brightness
#brew install --cask brisync

# Select default apps by cli tool
brew install duti

# Anybar
brew install --cask anybar

# Clipboard
brew install --cask maccy

# Storage
brew install --cask google-backup-and-sync
brew install --cask yandex-disk

# Torrents
brew install --cask transmission

# Media
brew install --cask vlc
brew install youtube-dl

# Phones
brew install --cask android-file-transfer
#brew install --cask ifunbox

# djview
brew install --cask djview

# Help unlucky windows guys
#brew install --cask teamviewer

# IM (choose what your need)
brew install --cask slack
brew install --cask skype
brew install --cask zoom
brew install --cask telegram
brew install --cask discord
brew install --cask whatsapp

# Avoid rkn
brew install --cask cloudflare-warp
brew install --cask protonvpn

# NTFS
# This driver is slow, writig speed 20x slower than on appfs. Better to use paragon ntfs.
#brew install --cask osxfuse
#brew install ntfs-3g
#sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
#sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

# Cleaner
# brew install --cask cleanmymac

# Tray improvements
brew install --cask itsycal

# Controls sleep
#brew install --cask caffeine

# os theme switcher
#brew install --cask nightowl

# Control GPUs
#brew install --cask gswitch

# Monitor temp
brew install --cask fanny

# Screen recording
#brew install --cask kap
#brew install asciinema

# IDE
#brew install --cask jetbrains-toolbox

# Screenshoting
#brew install --cask skitch

# Mindmap
brew install --cask xmind

# Graphs
#brew install --cask yed

# Emulator
#brew install --cask dosbox

# Manage ebooks
brew install --cask calibre

# Keyboard
brew install --cask karabiner-elements

# Images
# brew install --cask \
#   sketchbook \
#   adobe-photoshop-cc \
#   adobe-photoshop-lightroom

# Remove outdated versions from the cellar
brew cleanup

