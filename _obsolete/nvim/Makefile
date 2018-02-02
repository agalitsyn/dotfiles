CONFIG_FOLDER := ~/.config/nvim
BASH_HOOKS_FOLDER := ~/.bash.d

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f init.vim) $(CONFIG_FOLDER)
	ln -sf $$(readlink -f nvim.sh) $(BASH_HOOKS_FOLDER)/nvim.sh
