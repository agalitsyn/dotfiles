CONFIG_FOLDER := ~/.config/nvim
HOOKS_FOLDER := ~/.bash.d

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f init.vim) $(CONFIG_FOLDER)
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f nvim.sh) $(HOOKS_FOLDER)/nvim.sh
