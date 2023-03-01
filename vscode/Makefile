include ../vars.mk

.PHONY: install
install:
	for i in $(shell cat extensions.txt); do\
		code --install-extension $$i; \
	done

.PHONY: configure-linux
configure-linux:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/.config/Code/User/keybindings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json
	ln -sf $(CURDIR)/python.json ~/.config/Code/User/snippets/python.json
	ln -sf $(CURDIR)/vue.json ~/.config/Code/User/snippets/vue.json

.PHONY: configure-osx
configure-osx:
	ln -sf $(CURDIR)/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -sf $(CURDIR)/go.json ~/Library/Application\ Support/Code/User/snippets/go.json
	ln -sf $(CURDIR)/python.json ~/Library/Application\ Support/Code/User/snippets/python.json
	ln -sf $(CURDIR)/vue.json ~/Library/Application\ Support/Code/User/snippets/vue.json
