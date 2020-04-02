# Python, Django, Ansible, Docker packages
PACKAGES := ms-python.python \
			wholroyd.jinja \
			batisteo.vscode-django \
			mikestead.dotenv \
			ms-azuretools.vscode-docker \
			EditorConfig.EditorConfig \
			wayou.vscode-todo-highlight \
			esbenp.prettier-vscode \
			dbaeumer.vscode-eslint \
			PKief.material-icon-theme \
			tonsky.theme-alabaster

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES), code --install-extension $(pkg);)

.PHONY: configure
configure:
	# TODO: link for OSX too
	ln -sf $(CURDIR)/settings.json ~/.config/Code/User/settings.json
	ln -sf $(CURDIR)/go.json ~/.config/Code/User/snippets/go.json
