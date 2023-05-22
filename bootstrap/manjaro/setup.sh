# vim: tabstop=4 shiftwidth=4 noexpandtab

# For any DE

# OS: Manjaro Linux x86_64
# Host: 21B1 Lenovo ThinkBook 15p Gen 2
# Kernel: 5.15.65-1-MANJARO
# Shell: zsh 5.9
# CPU: 11th Gen Intel i7-11800H (16) @ 800MHz
# GPU: NVIDIA GeForce GTX 1650 Mobile / Max-Q
# GPU: Intel TigerLake-H GT1 [UHD Graphics]
# Memory: 3668MiB / 31886MiB

sudo pacman-mirrors --country Russia

sudo pacman -Syyu --noconfirm

sudo pacman -S --noconfirm git base-devel yay pamac
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf

# Trim for SSD
sudo systemctl enable fstrim.timer

# Detect current kernel
# See https://wiki.manjaro.org/index.php/Manjaro_Kernels
mhwd-kernel -li
# If you see error: GPGME error: No data try running sudo pacman-key --init

# Install kernel headers
yay -S --noconfirm linux515 linux515-headers

# Setup NVIDIA
sudo mhwd -a pci nonfree 0300

# After reboot re-run
nvidia-smi
#nvidia-settings

# Setup power management
yay -S --noconfirm tlp linux515-tp_smapi linux515-acpi_call
sudo systemctl enable tlp.service
sudo tlp start
yay -S --noconfirm powertop

yay -S --noconfirm brave-browser firefox
# Alternatives:
#yay -S --noconfirm firefox-developer-edition
#yay -S --noconfirm ungoogled-chromium-bin

yay -S --noconfirm alsa-utils pavucontrol

yay -S --noconfirm sublime-text-4 sublime-merge

yay -S --noconfirm visual-studio-code-bin
# Alternatives
# OSS build
# yay -S --noconfirm code
# Unmicrosofted vscode
# yay -S --noconfirm vscodium-bin

yay -S --noconfirm parcellite

yay -S --noconfirm yandex-disk yandex-disk-indicator
# Setup: https://yandex.com/support/disk-desktop-linux/start.html#cli-setup

yay -S --noconfirm font-manager

yay -S --noconfirm \
    ttf-ms-fonts \
    ttf-ibm-plex \
    ttf-juliamono \
    ttf-monofur \
    ttf-monoid \
    ttf-jetbrains-mono \
    ttf-roboto-mono \
    ttf-ubuntu-font-family \
    ttf-mac-fonts \
    adobe-source-code-pro-fonts \
    nerd-fonts-complete

yay -S --noconfirm neofetch

yay -S --noconfirm alacritty

yay -S --noconfirm tree curl tmux gettext sshpass
yay -S --noconfirm unrar p7zip pbzip2
yay -S --noconfirm htop iotop strace tcpdump mtr traceroute

yay -S --noconfirm mc ranger manjaro-ranger-settings

yay -S --noconfirm pdfarranger
yay -S --noconfirm zathura zathura-pdf-mupdf zathura-djvu

yay -S --noconfirm obsidian
yay -S --noconfirm obs-studio

# shell tools
yay -S --noconfirm \
    vim \
    neovim \
    git \
    tig \
    shellcheck \
    zsh \
    jq \
    yq \
    htmlq \
    ripgrep \
    z \
    exa \
    bat \
    git-delta \
    fd \
	fzf \
    atuin \
    tldr \
    httpie \
    hurl-bin

yay -S --noconfirm go
yay -S --noconfirm python
yay -S --noconfirm nodejs-lts-hydrogen npm yarn pnpm
yay -S --noconfirm jre-openjdk
yay -S --noconfirm protobuf

yay -S --noconfirm meld

yay -S --noconfirm graphviz

yay -S --noconfirm openvpn networkmanager-openvpn

yay -S --noconfirm docker docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
newgrp docker

yay -S --noconfirm podman podman-compose

yay -S --noconfirm ansible

yay -S --noconfirm imagemagick

yay -S --noconfirm vlc

yay -S --noconfirm libreoffice-fresh

yay -S --noconfirm postgresql-libs pgcli

yay -S --noconfirm telegram-desktop

yay -S --noconfirm flameshot

echo "Official packages"
pacman -Qn

echo "AUR packages"
pacman -Qm

# After install
#wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.25.12999.tar.gz

#sudo powertop --calibrate
#Navigate to "Tunables" tab and fix all the remaining issues by pressing enter staying on it.

# Setup gnome in settings and gnome-tweaks
# mkdir -pv ~/.local/share/gnome-shell/extensions directory.
# Download extensions
# Next, open metadata.json file inside it and check for the value of uuid and make sure it is the same value as extension folder’s name. If it isn’t, rename the folder to the value of the uuid.
# alt+f2 -> r
# Open extensions and enable them
