PACKAGES := ms-vscode.cpptools \
			ms-vscode.go \
			ms-python.python \
			ms-vscode.csharp \
			EditorConfig.EditorConfig \
			PeterJausovec.vscode-docker \
			PKief.material-icon-theme \
			wayou.vscode-todo-highlight

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES), code --install-extension $(pkg);)

.PHONY: configure
configure:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json
