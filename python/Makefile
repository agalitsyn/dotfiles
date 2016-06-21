CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f python.sh) $(HOOKS_FOLDER)/python.sh

install:
	$$(bash install.sh)
