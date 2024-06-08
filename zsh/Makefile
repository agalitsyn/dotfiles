include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/zshrc ~/.zshrc
	ln -sf $(CURDIR)/p10k.zsh ~/.p10k.zsh
	mkdir -pv $(ZSH_HOOKS_FOLDER)
	mkdir -pv $(ZSH_HOOKS_FOLDER)/themes
	ln -sf $(CURDIR)/zsh.d/aliases.zsh $(ZSH_HOOKS_FOLDER)/aliases.zsh
	touch $(ZSH_HOOKS_FOLDER)/local.zsh

.PHONY: install-theme
install-theme:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(ZSH_HOOKS_FOLDER)/themes/powerlevel10k

.PHONY: install-plugins
install-plugins:
	wget -O $(ZSH_HOOKS_FOLDER)/zsh-fzf-history-search.zsh https://raw.githubusercontent.com/joshskidmore/zsh-fzf-history-search/master/zsh-fzf-history-search.zsh

