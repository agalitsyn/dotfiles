CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f tmux.conf) $(CONFIG_FOLDER)/.tmux.conf
	ln -sf $$(readlink -f tmux.sh) $(HOOKS_FOLDER)/tmux.sh
