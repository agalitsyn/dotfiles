/bin/bash

set -ex

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Updating Homebrew"
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
    exa \
    bat \
    ripgrep \
    z \
    git-delta \
    lazygit \
    tig \
    xh \
    fzf \
    fd \
    tldr \
    zellij

# HTTP tools
brew isntall httpie

# Cert tools
brew install easy-rsa

# DB tools
brew install pgcli

# Add fonts
brew tap homebrew/cask-fonts
brew install --cask \
    font-source-code-pro \
    font-fira-code \
    font-hack \
    font-jetbrains-mono \
    font-cascadia-code \
    font-input \
    font-go \
    font-juliamono \
    font-ibm-plex-mono \
    font-iosevka \
    font-inconsolata \
    font-monoid \
    font-pt-mono \
    font-space-mono \
    font-martian-mono \
    font-blex-mono-nerd-font \
    font-jetbrains-mono-nerd-font \
    font-martian-mono-nerd-font \
    font-monaspace

# Necessary for CLI on images
brew install imagemagick

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

# DB packages, also required for build python packages
brew install \
    postgresql \
    libmemcached \
    memcached \
    redis \
    sqlite

# Javascript
brew install \
    node \
    yarn \
    pnpm

# Go
brew install go

# Java
brew install java openjdk

# Browsers
brew install --cask firefox
brew install --cask chromium --no-quarantine

# True editors
brew install vim neovim
# Noob editors
brew install --cask \
    sublime-text \
    sublime-merge \
    visual-studio-code

# Terminal
brew install --cask wezterm

# Firewall
brew install --cask lulu

# Sockets
brew install --cask sloth

# Hex editor
brew install --cask imhex

# Displays
brew install --cask monitorcontrol
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

# Cloud
brew install ansible \
    terraform

#brew install awscli
brew install doctl
brew install --cask yandex-cloud-cli

# Anybar
#brew install --cask anybar

# all in one tool
brew install --cask raycast

# Window management
# brew install --cask rectangle

# Clipboard manager
#brew install --cask maccy

# App switcher
#brew install --cask alt-tab

# Fix dumb Music.app autolaunch
brew install --cask notunes

# Cloud storage
#brew install --cask google-backup-and-sync
brew install --cask yandex-disk

# Torrents
brew install --cask transmission

# Media
brew install --cask vlc
brew install --cask handbrake
brew install youtube-dl

# Screenshot
#brew install --cask flameshot
#brew install --cask skitch

# Phones
brew install --cask android-file-transfer
brew install --cask imazing
#brew install --cask ifunbox

# IM (choose what your need)
#brew install --cask slack
#brew install --cask skype
#brew install --cask discord
#brew install --cask zoom
#brew install --cask whatsapp
brew install --cask telegram

# VPN
brew install --cask tunnelblick
brew install --cask wireguard-tools
#brew install --cask cloudflare-warp
#brew install --cask protonvpn
#brew install --cask tor-browser

# Tray improvements
brew install --cask itsycal
brew install --cask hiddenbar

# Mindmap
# Manually download xmind 8 from website https://xmind.app/download/xmind8/
# xmind from brew is xmind zen, which is bad
#brew install --cask xmind

# Notes
brew install --cask obsidian

# Password manager
brew install bitwarden-cli
brew install --cask bitwarden

# Graphs
brew install graphviz
brew install plantuml
#brew install mermaid-cli
#brew install --cask yed

# E-books
brew install --cask calibre
brew install --cask djview
#brew install --cask kindle

# Record screen
brew install --casks obs
#brew install asciinema
#brew install --cask kap

# Create Linux USB drives
brew install --cask balenaetcher

# Help unlucky windows guys
#brew install --cask teamviewer
brew install --cask anydesk

# NTFS
#
# This driver is slow, writig speed 20x slower than on appfs.
#brew install --cask osxfuse
#brew install ntfs-3g
#sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
#sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs
#
# Better to use paragon ntfs.
brew install --cask paragon-ntfs
# For native driver
#brew install --cask mounty

# Some not free apps
#brew install --cask microsoft-office

# Remove outdated versions from the cellar
brew cleanup
