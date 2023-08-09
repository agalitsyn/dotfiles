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
    pv

# Add utilities
brew tap daipeihust/tap && brew install im-select

# cli editor
brew install vim \
    ctags \
    shellcheck

# New cli tools
brew install \
    jq \
    yq \
    exa \
    bat \
    ripgrep \
    z \
    git-delta \
    tig \
    xh \
    fzf \
    fd \
    tldr

# HTTP tools
brew isntall httpie
#brew install --cask insomnia

# SS with UI
brew install --cask sloth

# Cert tools
brew install easy-rsa

# DB tools
brew install pgcli
#brew install --cask pgadmin4
#brew install --cask dbeaver-community

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
    font-blex-mono-nerd-font \
    font-jetbrains-mono-nerd-font

# Necessary for CLI on images
brew install imagemagick

# Editor
brew install --cask \
    sublime-text \
    sublime-merge \
    visual-studio-code

# Separate vscode for experiments
brew install --cask vscodium

# Programming
brew install \
    python \
    pyenv \
    poetry \
    pdm \
    node@16 \
    yarn \
    pnpm \
    go

# Add backing services primarily for python builds
brew install \
    postgresql \
    libmemcached \
    memcached \
    redis \
    sqlite

# Alternative for Finder
brew install --cask marta

# Finder quicklook plugins
brew install --cask WebPQuickLook

# Virt
#brew install --cask virtualbox \
#    virtualbox-extension-pack \
#    vagrant

# Containers
brew install --cask docker
brew install lazydocker
brew install ctop

# Cloud OPS tools
brew install ansible \
    terraform

# AWS tools
#brew install awscli

# Digital Ocean tools
brew install doctl

# Yandex cloud tools
brew install --cask yandex-cloud-cli

# Browsers
brew install --cask firefox \
    google-chrome

# Terminal
brew install --cask iterm2

# Window management
#brew install --cask spectacle
brew install --cask rectangle

# External monitor tool
#brew install --cask avibrazil-rdm
brew install --cask monitorcontrol

# Select default apps by cli tool
brew install duti

# Anybar
brew install --cask anybar

# Clipboard manager
brew install --cask maccy

# App switch
#brew install --cask alt-tab

# Storage
#brew install --cask google-backup-and-sync
brew install --cask yandex-disk

# Torrents
brew install --cask transmission

# Media
brew install --cask vlc
brew install --cask handbrake
brew install youtube-dl

# Screenshot
brew install --cask flameshot
#brew install --cask skitch

# Phones
brew install --cask android-file-transfer
brew install --cask imazing
#brew install --cask ifunbox

# IM (choose what your need)
#brew install --cask slack
#brew install --cask skype
#brew install --cask discord
brew install --cask zoom
brew install --cask telegram
brew install --cask whatsapp

# Avoid rkn
brew install --cask tunnelblick
#brew install --cask cloudflare-warp
#brew install --cask protonvpn
#brew install --cask tor-browser

# Tray improvements
brew install --cask itsycal

# IDE
brew install --cask jetbrains-toolbox

# Mindmap
# Manually download xmind 8 from website https://xmind.app/download/xmind8/
# xmind from brew is xmind zen, which is bad
#brew install --cask xmind

# Notes
brew install --cask obsidian

# Password manager
brew install bitwarden-cli
brew install --casks bitwarden

# Graphs
#brew install --cask yed
brew install mermaid-cli
brew install graphviz

# Emulator
#brew install --cask dosbox

# Manage ebooks
brew install --cask calibre
brew install --cask djview
#brew install --cask kindle

# Keyboard
brew install --cask karabiner-elements

# Record screen
brew install --casks obs
#brew install asciinema
#brew install --cask kap

# Linux USB drives
brew install --cask balenaetcher

# Open rar files
brew install --cask the-unarchiver

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
#Better to use paragon ntfs.
brew install --cask paragon-ntfs
#
# For native driver
#brew install --cask mounty

# Some not free apps
#brew install --cask cleanmymac
#brew install --cask microsoft-office

# Remove outdated versions from the cellar
brew cleanup

