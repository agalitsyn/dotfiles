CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f docker.sh) $(HOOKS_FOLDER)/docker.sh
