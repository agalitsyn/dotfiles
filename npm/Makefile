CONFIG_FOLDER := ~

configure:
	ln -sf $$(readlink -f npmrc) $(CONFIG_FOLDER)/.npmrc

install:
	$$(bash install.sh)
