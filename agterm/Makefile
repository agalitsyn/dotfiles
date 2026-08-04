include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/agterm.sh $(ZSH_HOOKS_FOLDER)/agterm.zsh
	mkdir -pv ~/.config/agterm
	ln -sf $(CURDIR)/keymap.conf ~/.config/agterm/keymap.conf
	ln -sf $(CURDIR)/ghostty.conf ~/.config/agterm/ghostty.conf
	ln -sf $(CURDIR)/agterm-notify.sh ~/.config/agterm/agterm-notify.sh

