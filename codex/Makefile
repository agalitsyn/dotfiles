include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/codex.sh $(ZSH_HOOKS_FOLDER)/codex.zsh
	mkdir -pv ~/.codex
	if [ -L ~/.codex/config.toml ] || [ ! -e ~/.codex/config.toml ]; then \
		cp $(CURDIR)/config.toml ~/.codex/config.toml.tmp && mv -f ~/.codex/config.toml.tmp ~/.codex/config.toml; \
	fi
	ln -sf $(CURDIR)/trust-repos.sh ~/.codex/trust-repos.sh
	if [ -L ~/.codex/rules ]; then rm -f ~/.codex/rules; fi
	mkdir -pv ~/.codex/rules
	ln -sf $(CURDIR)/rules/dotfiles.rules ~/.codex/rules/dotfiles.rules
	ln -sfn $(CURDIR)/skills ~/.codex/skills
