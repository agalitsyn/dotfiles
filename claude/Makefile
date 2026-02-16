include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/ai.sh $(ZSH_HOOKS_FOLDER)/ai.zsh
	ln -sf $(CURDIR)/settings.json ~/.claude/settings.json
	ln -sf $(CURDIR)/statusline-command.sh ~/.claude/statusline-command.sh

.PHONY: install
install:
	curl -fsSL https://claude.ai/install.sh | bash

