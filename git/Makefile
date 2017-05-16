CONFIG_FOLDER := ~
BASH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d
ZSH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.zsh.d

.PHONY: configure
configure:
	ln -sf $$(readlink -f gitconfig) $(CONFIG_FOLDER)/.gitconfig
	ln -sf $$(readlink -f gitignore) $(CONFIG_FOLDER)/.gitignore
	ln -sf $$(readlink -f git.sh) $(BASH_HOOKS_FOLDER)/git.sh
	ln -sf $$(readlink -f git.zsh) $(ZSH_HOOKS_FOLDER)/git.zsh
