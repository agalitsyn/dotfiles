include ../vars.mk

.PHONY: configure
configure:
	ln -sf bash_profile ~/.bash_profile
	ln -sf bashrc ~/.bashrc
	ln -sf inputrc ~/.inputrc
	mkdir -pv $(BASH_HOOKS_FOLDER)
	ln -sf bash.d/prompt.sh $(BASH_HOOKS_FOLDER)/prompt.sh
	ln -sf bash.d/aliases.sh $(BASH_HOOKS_FOLDER)/aliases.sh
	ln -sf bash.d/exports.sh $(BASH_HOOKS_FOLDER)/exports.sh
	ln -sf bash.d/functions.sh $(BASH_HOOKS_FOLDER)/functions.sh
