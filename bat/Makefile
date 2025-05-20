.PHONY: configure
configure:
	mkdir -pv ~/.config/bat/themes
	ln -sf $(CURDIR)/config ~/.config/bat/config
	wget -O ~/.config/bat/themes/everforest.tmTheme https://raw.githubusercontent.com/mhanberg/everforest-textmate/main/Everforest%20Dark/Everforest%20Dark.tmTheme
	bat cache --build
	bat --list-themes | grep -i forest

