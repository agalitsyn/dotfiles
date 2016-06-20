CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	ln -s gitconfig $(CONFIG_FOLDER)/.gitconfig
	ln -s gitignore $(CONFIG_FOLDER)/.gitignore
	mkdir -pv $(HOOKS_FOLDER)
	ln -s bash.d/git.sh $(HOOKS_FOLDER)/git.sh
