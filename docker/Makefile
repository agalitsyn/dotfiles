CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f bash.d/docker.sh) $(HOOKS_FOLDER)/docker.sh
