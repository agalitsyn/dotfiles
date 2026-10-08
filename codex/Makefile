include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/codex.sh $(ZSH_HOOKS_FOLDER)/codex.zsh
	mkdir -pv ~/.codex
	ln -sf $(CURDIR)/config.toml ~/.codex/config.toml
	ln -sfn $(CURDIR)/rules ~/.codex/rules
	ln -sfn $(CURDIR)/skills ~/.codex/skills
