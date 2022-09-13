# OS: Manjaro Linux x86_64 
# Host: 21B1 Lenovo ThinkBook 15p Gen 2 
# Kernel: 5.15.65-1-MANJARO 
# Uptime: 2 hours, 41 mins 
# Packages: 1124 (pacman) 
# Shell: zsh 5.9 
# Resolution: 1920x1080 
# DE: GNOME 42.4 
# WM: Mutter 
# WM Theme: Adwaita 
# Theme: Adw-dark [GTK2/3] 
# Icons: Papirus-Dark [GTK2/3] 
# Terminal: gnome-terminal 
# CPU: 11th Gen Intel i7-11800H (16) @ 800MHz 
# GPU: NVIDIA GeForce GTX 1650 Mobile / Max-Q 
# GPU: Intel TigerLake-H GT1 [UHD Graphics] 
# Memory: 3668MiB / 31886MiB 

# also see https://github.com/lionell/manjaro-guide

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
yay -S --noconfirm  linux515 linux515-headers

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


yay -S --noconfirm google-chrome

yay -S --noconfirm gnome-disk-utility gnome-keyring

yay -S --noconfirm sublime-text-4 sublime-merge
yay -S --noconfirm visual-studio-code-bin

yay -S --noconfirm parcellite

yay -S --noconfirm yandex-disk yandex-disk-indicator

yay -S --noconfirm ttf-ms-fonts
yay -S --noconfirm adobe-source-code-pro-fonts


yay -S --noconfirm neofetch


yay -S --noconfirm termite

yay -S --noconfirm tree curl tmux gettext
yay -S --noconfirm unrar p7zip pbzip2
yay -S --noconfirm htop iotop strace tcpdump mtr traceroute


# IDE
yay -S --noconfirm \
	vim \
	neovim \
	ctags \
	git \
	tig \
	shellcheck \
	jq \
	httpie \
	zsh \
	jq \
	yq \
	ripgrep \
	z \
	exa \
	bat \
	git-delta
	

yay -S --noconfirm go python nodejs-lts-gallium jre-openjdk

yay -S --noconfirm meld

yay -S --noconfirm graphviz    

yay -S --noconfirm openvpn networkmanager-openvpn

yay -S --noconfirm docker docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
newgrp docker

yay -S --noconfirm ansible

yay -S --noconfirm  imagemagick

yay -S --noconfirm  vlc

yay -S --noconfirm  libreoffice-fresh

yay -S --noconfirm  postgresql-libs pgcli

yay -S --noconfirm zoom telegram-desktop


echo "Official packages"
pacman -Qn

echo "AUR packages"
pacman -Qm

# After install
#wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.25.12999.tar.gz

#sudo powertop --calibrate
#Navigate to "Tunables" tab and fix all the remaining issues by pressing enter staying on it.

# gnome-tweaks
