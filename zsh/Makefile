include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/zshrc ~/.zshrc
	ln -sf $(CURDIR)/p10k.zsh ~/.p10k.zsh
	mkdir -pv $(ZSH_HOOKS_FOLDER)
	ln -sf $(CURDIR)/zsh.d/aliases.zsh $(ZSH_HOOKS_FOLDER)/aliases.zsh
	ln -sf $(CURDIR)/zsh.d/themes $(ZSH_HOOKS_FOLDER)/themes
	touch $(ZSH_HOOKS_FOLDER)/local.zsh

.PHONY: install
install:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(ZSH_HOOKS_FOLDER)/themes/powerlevel10k

