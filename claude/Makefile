include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/claude.sh $(ZSH_HOOKS_FOLDER)/claude.zsh
	ln -sf $(CURDIR)/settings.json ~/.claude/settings.json
	ln -sf $(CURDIR)/CLAUDE.global.md ~/.claude/CLAUDE.md
	ln -sf $(CURDIR)/statusline-command.sh ~/.claude/statusline-command.sh
	ln -sf $(CURDIR)/trust-repos.sh ~/.claude/trust-repos.sh
	ln -sfn $(CURDIR)/skills ~/.claude/skills
	npx -y skills add hackmajoris/skills/skills/rebased-review -g -y -a claude-code codex

