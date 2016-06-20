CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

configure:
	ln -sf $$(readlink -f gitconfig) $(CONFIG_FOLDER)/.gitconfig
	ln -sf $$(readlink -f gitignore) $(CONFIG_FOLDER)/.gitignore
	mkdir -pv $(HOOKS_FOLDER)
	ln -sf $$(readlink -f bash.d/git.sh) $(HOOKS_FOLDER)/git.sh
