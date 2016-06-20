CONFIG_FOLDER := ~/.config
HOOKS_FOLDER := ~/.bash.d

configure:
	rm -rfv ~/.i3
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f i3) $(CONFIG_FOLDER)/i3
	ln -sf $$(readlink -f i3status) $(CONFIG_FOLDER)/i3status
	ln -sf $$(readlink -f dunst) $(CONFIG_FOLDER)/dunst
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f wm.sh) $(HOOKS_FOLDER)/wm.sh
