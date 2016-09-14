CONFIG_FOLDER := ~/.ssh
HOOKS_FOLDER := ~/.bash.d

.PHONY: configure
configure:
	mkdir -pv $(CONFIG_FOLDER)
	cp config $(CONFIG_FOLDER)/config
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f ssh.sh) $(HOOKS_FOLDER)/ssh.sh
