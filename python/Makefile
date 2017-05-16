CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f python.sh) $(HOOKS_FOLDER)/python.sh

.PHONY: install
install:
	$$(bash install.sh)
