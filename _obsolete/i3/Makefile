CONFIG_FOLDER := ~/.config
BASH_HOOKS_FOLDER := ~/.bash.d

.PHONY: configure
configure:
	rm -rfv ~/.i3
	mkdir -pv $(CONFIG_FOLDER)/i3status
	ln -sf $$(readlink -f i3status/config) $(CONFIG_FOLDER)/i3status/config
	mkdir -pv $(CONFIG_FOLDER)/dunst
	ln -sf $$(readlink -f dunst/dunstrc) $(CONFIG_FOLDER)/dunst/dunstrc
	mkdir -pv $(CONFIG_FOLDER)/i3
	ln -sf $$(readlink -f i3/config) $(CONFIG_FOLDER)/i3/config
	ln -sf $$(readlink -f wm.sh) $(BASH_HOOKS_FOLDER)/wm.sh
