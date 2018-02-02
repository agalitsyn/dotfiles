CONFIG_FOLDER := ~
BASH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.zsh.d

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	ln -sf $$(readlink -f zshrc) $(CONFIG_FOLDER)/.zshrc
	mkdir -pv $(BASH_HOOKS_FOLDER)
	ln -sf $$(readlink -f zsh.d/themes) $(BASH_HOOKS_FOLDER)/themes
