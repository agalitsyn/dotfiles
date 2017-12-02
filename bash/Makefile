CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(greadlink -f bash_profile) $(CONFIG_FOLDER)/.bash_profile
	ln -sf $$(greadlink -f bashrc) $(CONFIG_FOLDER)/.bashrc
	ln -sf $$(greadlink -f inputrc) $(CONFIG_FOLDER)/.inputrc
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(greadlink -f bash.d/prompt.sh) $(HOOKS_FOLDER)/prompt.sh
	ln -sf $$(greadlink -f bash.d/aliases.sh) $(HOOKS_FOLDER)/aliases.sh
	ln -sf $$(greadlink -f bash.d/exports.sh) $(HOOKS_FOLDER)/exports.sh
	ln -sf $$(greadlink -f bash.d/functions.sh) $(HOOKS_FOLDER)/functions.sh
