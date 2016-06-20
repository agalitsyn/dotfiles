CONFIG_FOLDER := ~/.config/fontconfig/conf.d 

configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f 04-adjust.conf) $(CONFIG_FOLDER)/.04-adjust.conf
