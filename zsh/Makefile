include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/zshrc ~/.zshrc
	mkdir -pv $(ZSH_HOOKS_FOLDER)
	ln -sf $(CURDIR)/zsh.d/aliases.zsh $(ZSH_HOOKS_FOLDER)/aliases.zsh
	ln -sf $(CURDIR)/zsh.d/themes $(ZSH_HOOKS_FOLDER)/themes

.PHONY: install
install:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
