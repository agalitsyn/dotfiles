include ../vars.mk

.PHONY: configure
configure:
	mkdir -pv ~/.ssh
	cp config ~/.ssh/config
	ln -sf ssh.sh $(BASH_HOOKS_FOLDER)/ssh.sh
