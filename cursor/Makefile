include ../vars.mk

.PHONY: install-extensions
install-extensions:
	for i in $(shell cat extensions.txt); do\
		cursor --install-extension $$i --force; \
	done

.PHONY: dump-extensions
dump-extensions:
	cursor --list-extensions > extensions.txt

.PHONY: configure
configure:
	ln -sf $(CURDIR)/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
	ln -sf $(CURDIR)/snippets ~/Library/Application\ Support/Cursor/User

