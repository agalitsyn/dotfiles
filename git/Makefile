include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/gitconfig ~/.gitconfig
	ln -sf $(CURDIR)/gitignore ~/.gitignore
	touch ~/.gitconfig.local
	ln -sf $(CURDIR)/git.zsh $(ZSH_HOOKS_FOLDER)/git.zsh

