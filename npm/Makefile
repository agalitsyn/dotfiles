CONFIG_FOLDER := ~

.PHONY: all
all: install configure

.PHONY: configure
configure:
	ln -sf $$(readlink -f npmrc) $(CONFIG_FOLDER)/.npmrc

.PHONY: install
install:
	$$(bash install.sh)
