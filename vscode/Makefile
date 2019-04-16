PACKAGES := ms-vscode.cpptools \
			ms-vscode.go \
			ms-python.python \
			ms-vscode.csharp \
			ms-kubernetes-tools.vscode-kubernetes-tools \
			EditorConfig.EditorConfig \
			PeterJausovec.vscode-docker \
			PKief.material-icon-theme \
			wayou.vscode-todo-highlight \
			fatihacet.gitlab-workflow

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES), code --install-extension $(pkg);)

.PHONY: configure
configure:
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json
