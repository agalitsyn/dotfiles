include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/zshrc ~/.zshrc
	mkdir -pv $(ZSH_HOOKS_FOLDER)
	ln -sf $(CURDIR)/zsh.d/themes $(ZSH_HOOKS_FOLDER)/themes
