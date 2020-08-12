PACKAGES := ms-python.python \
			wholroyd.jinja \
			batisteo.vscode-django \
			mikestead.dotenv \
			ms-azuretools.vscode-docker \
			editorconfig.editorconfig \
			wayou.vscode-todo-highlight \
			pkief.material-icon-theme \
			tonsky.theme-alabaster \
			christian-kohler.path-intellisense \
			golang.go \
			vscoss.vscode-ansible

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

