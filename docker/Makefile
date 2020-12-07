include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/docker.sh $(BASH_HOOKS_FOLDER)/docker.sh
	ln -sf $(CURDIR)/docker-compose.sh $(BASH_HOOKS_FOLDER)/docker-compose.sh
	ln -sf $(CURDIR)/docker.sh $(ZSH_HOOKS_FOLDER)/docker.zsh
	ln -sf $(CURDIR)/docker-compose.sh $(ZSH_HOOKS_FOLDER)/docker-compose.zsh
