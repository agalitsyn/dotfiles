include ../vars.mk

.PHONY: configure
configure:
	mkdir -pv ~/.ssh
	cp $(CURDIR)/config ~/.ssh/config
	ln -sf $(CURDIR)/ssh.sh $(BASH_HOOKS_FOLDER)/ssh.sh
