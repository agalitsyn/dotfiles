CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f tmux.conf) $(CONFIG_FOLDER)/.tmux.conf
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f tmux.sh) $(HOOKS_FOLDER)/tmux.sh
