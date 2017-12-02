CONFIG_FOLDER := ~
BASH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d
ZSH_HOOKS_FOLDER := $(CONFIG_FOLDER)/.zsh.d

.PHONY: configure
configure:
	ln -sf $$(greadlink -f osx.sh) $(BASH_HOOKS_FOLDER)/osx.sh
	ln -sf $$(greadlink -f osx.zsh) $(ZSH_HOOKS_FOLDER)/osx.zsh
