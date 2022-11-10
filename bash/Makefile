include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/bash_profile ~/.bash_profile
	ln -sf $(CURDIR)/bashrc ~/.bashrc
	ln -sf $(CURDIR)/inputrc ~/.inputrc
	mkdir -pv $(BASH_HOOKS_FOLDER)
	ln -sf $(CURDIR)/bash.d/prompt.sh $(BASH_HOOKS_FOLDER)/prompt.sh
	ln -sf $(CURDIR)/bash.d/aliases.sh $(BASH_HOOKS_FOLDER)/aliases.sh
	ln -sf $(CURDIR)/bash.d/exports.sh $(BASH_HOOKS_FOLDER)/exports.sh
	ln -sf $(CURDIR)/bash.d/functions.sh $(BASH_HOOKS_FOLDER)/functions.sh
	touch $(BASH_HOOKS_FOLDER)/local.sh

