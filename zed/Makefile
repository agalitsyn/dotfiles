.PHONY: configure
configure:
	# in case it not fresh install
	# mv ~/.config/zed ~/.config/zed.backup
	# mv ~/Library/Application\ Support/Zed ~/Library/Application\ Support/Zed.backup
	mkdir -pv ~/.config/zed
	mkdir -pv ~/Library/Application\ Support/Zed/extensions
	mv -f ~/.config/zed/settings.json ~/.config/zed/settings.prev.json
	cp -f $(CURDIR)/settings.json ~/.config/zed/settings.json
	ln -sf $(CURDIR)/keymap.json ~/.config/zed/keymap.json
	ln -sf $(CURDIR)/tasks.json ~/.config/zed/tasks.json
	ln -sf $(CURDIR)/snippets ~/.config/zed/snippets
	ln -sf $(CURDIR)/themes ~/.config/zed/themes
	ln -sf $(CURDIR)/extensions/index.json ~/Library/Application\ Support/Zed/extensions/index.json
