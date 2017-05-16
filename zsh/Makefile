CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.zsh.d

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f zshrc) $(CONFIG_FOLDER)/.zshrc
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f zsh.d/themes) $(HOOKS_FOLDER)/themes
