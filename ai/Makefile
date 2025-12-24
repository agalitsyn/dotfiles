include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/aider.conf.yml ~/.aider.conf.yml

.PHONY: install
install:
	curl -fsSL https://claude.ai/install.sh | bash
	uv tool install --force --python python3.12 aider-chat@latest
