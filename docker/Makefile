CONFIG_FOLDER := ~
BASH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d
ZSH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.zsh.d


.PHONY: configure
configure:
	ln -sf $$(readlink -f docker.sh) $(BASH_HOOKS_FOLDER)/docker.sh
	ln -sf $$(readlink -f docker.zsh) $(ZSH_HOOKS_FOLDER)/docker.zsh
