include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/osx.sh $(ZSH_HOOKS_FOLDER)/osx.zsh

.PHONY: dump
dump:
	brew bundle dump --force --describe --no-restart --no-vscode --file $(CURDIR)/install/Brewfile

