CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	ln -sf bash_profile $(CONFIG_FOLDER)/.bash_profile
	ln -sf bashrc $(CONFIG_FOLDER)/.bashrc
	ln -sf inputrc $(CONFIG_FOLDER)/.inputrc
	mkdir -pv $(HOOKS_FOLDER)
	ln -s bash.d/prompt.sh $(HOOKS_FOLDER)/prompt.sh
	ln -s bash.d/aliases.sh $(HOOKS_FOLDER)/aliases.sh
	ln -s bash.d/exports.sh $(HOOKS_FOLDER)/exports.sh
	ln -s bash.d/functions.sh $(HOOKS_FOLDER)/functions.sh
