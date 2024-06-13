include ../vars.mk

.PHONY: install-extensions
install-extensions:
	for i in $(shell cat extensions.txt); do\
		code --install-extension $$i --force; \
	done

.PHONY: dump-extensions
dump-extensions:
	code --list-extensions > extensions.txt

.PHONY: configure-linux
configure-linux:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/.config/Code/User/keybindings.json
	ln -sf $(CURDIR)/snippets ~/.config/Code/User/snippets

.PHONY: configure-osx
configure-osx:
	ln -sf $(CURDIR)/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -sf $(CURDIR)/tasks.json ~/Library/Application\ Support/Code/User/tasks.json
	ln -sf $(CURDIR)/snippets ~/Library/Application\ Support/Code/User

