PACKAGES := batisteo.vscode-django \
			christian-kohler.path-intellisense \
			EditorConfig.EditorConfig \
			formulahendry.auto-close-tag \
			golang.go \
			HookyQR.beautify \
			mikestead.dotenv \
			ms-azuretools.vscode-docker \
			ms-python.python \
			ms-vscode.sublime-keybindings \
			PKief.material-icon-theme \
			tonsky.theme-alabaster \
			vscoss.vscode-ansible \
			wayou.vscode-todo-highlight \
			wholroyd.jinja

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES), code --install-extension $(pkg);)

.PHONY: configure-linux
configure-linux:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/keybindings.json ~/.config/Code/User/keybindings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json

.PHONY: configure-osx
configure-osx:
	ln -sf $(CURDIR)/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/Library/Application\ Support/Code/User/snippets/go.json

