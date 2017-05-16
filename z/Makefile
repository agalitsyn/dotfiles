CONFIG_FOLDER := ~
HOOKS_FOLDER := $(CONFIG_FOLDER)/.bash.d

.PHONY: all
all: install configure

.PHONY: install
install:
	git clone https://github.com/rupa/z.git $$PROJECTS/src/github.com/rupa/z

.PHONY: configure
configure:
	ln -sf $$(readlink -f z.sh) $(HOOKS_FOLDER)/z.sh
