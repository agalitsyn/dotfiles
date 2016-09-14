CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f docker.sh) $(HOOKS_FOLDER)/docker.sh
