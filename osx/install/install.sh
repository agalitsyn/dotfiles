#!/bin/bash

set -ex

if [[ $(command -v brew) == "" ]]; then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Updating homebrew"
    brew update
fi

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
    tig \
    tmux \
    curl \
    telnet \
    wget \
    tree \
    netcat \
    pv \
    htop \
    neofetch

# Newer blazingly fast cli tools, in Rust btw
brew install \
    jq \
    yq \
    eza \
    bat \
    ripgrep \
    fd \
    z \
    git-delta \
    lazygit \
    xh \
    fzf \
    tldr \
    tz \
    yazi

# HTTP tools
brew install httpie

# Cert tools
brew install easy-rsa

# Reverse engineering tools
brew install \
    nmap \
    gobuster

# Add fonts
brew tap homebrew/cask-fonts
brew install --cask \
    font-hack \
    font-input \
    font-jetbrains-mono-nerd-font \
    font-iosevka \
    font-iosevka-term-nerd-font \
    font-iosevka-nerd-font

# Necessary for CLI on images
brew install imagemagick

# DB packages, also required for build python packages
brew install \
    postgresql@17 \
    libmemcached \
    memcached \
    redis \
    sqlite

# Postgres client
brew install pgcli

# Native Mac app for PostgreSQL
# brew install --cask postico

# sqlite client
brew install litecli

# Kafka client
brew install kcat

# Mongo client
# brew install --cask studio-3t

# Go
brew install go

# Python
brew install \
    python \
    pyenv \
    poetry \
    pdm \
    ipython \
    pipx \
    ruff \
    cookiecutter

# JS
brew install \
    node \
    yarn \
    pnpm

# Java
brew install java openjdk

# Elixir
brew install elixir

# Browsers
brew install --cask firefox
brew install --cask brave-browser
# brew install --cask eloston-chromium --no-quarantine
# brew install --cask google-chrome
# brew install --cask yandex

# True editors
brew install vim \
    neovim

# Noob's editors
brew install --cask \
    sublime-text \
    sublime-merge \
    visual-studio-code

# Absolute noob's editors
brew install --cask jetbrains-toolbox

# AI code tools
brew install ollama
brew install --cask zed

# Terminal
brew install --cask wezterm

# Firewall
brew install --cask lulu

# SS UI
brew install --cask sloth

# Hex editor
brew install --cask imhex

# Network
# brew install --cask wireshark
# brew install --cask burp-suite

# Displays
# brew install --cask monitorcontrol
# Not needed on newer macos, because it has "show all resolutions"
#brew install --cask usr-sse2-rdm

# Tool for changing keyboard layouts
brew tap daipeihust/tap && brew install im-select

# Select default apps from cli
brew install duti

# Alternative for Finder
brew install --cask marta

# Finder quicklook plugins
brew install --cask \
    WebPQuickLook \
    quicklook-csv \
    quicklook-json

# Open rar files
brew install --cask the-unarchiver

# Uninstall helper
brew install --cask appcleaner

# Keyboard
brew install --cask karabiner-elements

# Virtualization
#brew install --cask virtualbox \
#    virtualbox-extension-pack \
#    vagrant

# Emulation
#brew install --cask dosbox

# Containers
brew install --cask docker
brew install lazydocker
brew install ctop

# Configuration
brew install ansible

# Cloud
# brew install awscli
# brew install doctl
# brew install --cask yandex-cloud-cli

# Anybar
# brew install --cask anybar

# All in one tool
brew install --cask raycast
# Window management
# brew install --cask rectangle
# Clipboard manager
# brew install --cask maccy
# App switcher
# brew install --cask alt-tab

# Fix dumb Music.app autolaunch
brew install --cask notunes

# Cloud storage
# brew install --cask google-backup-and-sync
brew install --cask yandex-disk

# Torrents
brew install --cask transmission

# Media
brew install --cask vlc
brew install --cask handbrake
brew install yt-dlp

# Screenshot
#brew install --cask flameshot
#brew install --cask skitch

# Phones
brew install --cask android-file-transfer
brew install --cask imazing
# brew install --cask ifunbox

# IM (choose what your need)
# brew install --cask slack
# brew install --cask skype
# brew install --cask whatsapp
# brew install --cask zoom
# brew install --cask discord
brew install --cask telegram

# VPN
brew install --cask openvpn-connect
# brew install --cask tunnelblick
# brew install spoofdpi

# Tray improvements
brew install --cask itsycal
#brew install --cask hiddenbar

# Mindmap
# Manually download xmind 8 from website https://xmind.app/download/xmind8/
# xmind from brew is xmind zen, which is bad
# brew install --cask xmind

# Notes
brew install --cask obsidian

# Password manager
brew install bitwarden-cli
brew install --cask bitwarden

# Graphs
brew install graphviz
brew install plantuml
# brew install mermaid-cli
# brew install --cask yed

# E-books
brew install --cask calibre
brew install --cask djview
# brew install --cask kindle

# Record screen
brew install --casks obs
# brew install asciinema
# brew install --cask kap

# Create Linux USB drives
brew install --cask balenaetcher

##    Windows

# Remote desktop
brew install --cask anydesk
# brew install --cask microsoft-remote-desktop
# brew install --cask teamviewer

# NTFS
#brew install --cask paragon-ntfs
#
# Other drivers are slow, writig speed 20x slower than on appfs.
# brew install --cask osxfuse
# brew install ntfs-3g
# sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
# sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs
#
# For native driver
# brew install --cask mounty

# Office
# brew install --cask microsoft-office

# Remove outdated versions from the cellar
brew cleanup

