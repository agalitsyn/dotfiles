CONFIG_FOLDER := ~

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f vimrc) $(CONFIG_FOLDER)/.vimrc
