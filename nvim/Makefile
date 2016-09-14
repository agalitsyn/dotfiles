CONFIG_FOLDER := ~/.config/nvim

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f init.vim) $(CONFIG_FOLDER)
