.PHONY: configure
configure:
	mkdir -pv "$(bat --config-dir)/themes"
	wget -O "$(bat --config-dir)/themes/everforest.tmTheme" https://raw.githubusercontent.com/mhanberg/everforest-textmate/main/Everforest%20Dark/Everforest%20Dark.tmTheme
	bat cache --build
	bat --list-themes | grep -i forest

