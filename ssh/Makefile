CONFIG_FOLDER := ~/.ssh
HOOKS_FOLDER := ~/.bash.d

configure:
	cp config $(CONFIG_FOLDER)/config
	mkdir -pv $(HOOKS_FOLDER)
	ln -s ssh.sh $(HOOKS_FOLDER)/ssh.sh
