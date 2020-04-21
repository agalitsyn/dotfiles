PACKAGES := ms-python.python \
			wholroyd.jinja \
			batisteo.vscode-django \
			mikestead.dotenv \
			ms-azuretools.vscode-docker \
			EditorConfig.EditorConfig \
			wayou.vscode-todo-highlight \
			PKief.material-icon-theme \
			tonsky.theme-alabaster \
			christian-kohler.path-intellisense \
			ms-vscode.sublime-keybindings \
			ms-vscode.go

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES), code --install-extension $(pkg);)

.PHONY: configure-linux
configure-linux:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json

.PHONY: configure-osx
configure-osx:
	ln -sf $(CURDIR)/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/Library/Application\ Support/Code/User/snippets/go.json

