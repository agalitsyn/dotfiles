CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	ln -sf $$(readlink -f bash_profile) $(CONFIG_FOLDER)/.bash_profile
	ln -sf $$(readlink -f bashrc) $(CONFIG_FOLDER)/.bashrc
	ln -sf $$(readlink -f inputrc) $(CONFIG_FOLDER)/.inputrc
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f bash.d/prompt.sh) $(HOOKS_FOLDER)/prompt.sh
	ln -sf $$(readlink -f bash.d/aliases.sh) $(HOOKS_FOLDER)/aliases.sh
	ln -sf $$(readlink -f bash.d/exports.sh) $(HOOKS_FOLDER)/exports.sh
	ln -sf $$(readlink -f bash.d/functions.sh) $(HOOKS_FOLDER)/functions.sh
