CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f chrome.sh) $(HOOKS_FOLDER)/chrome.sh
