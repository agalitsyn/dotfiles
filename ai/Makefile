include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/aider.conf.yml ~/.aider.conf.yml

.PHONY: install
install:
	npm install -g @anthropic-ai/claude-code
	npm install -g @openai/codex
	uv tool install --force --python python3.12 aider-chat@latest
