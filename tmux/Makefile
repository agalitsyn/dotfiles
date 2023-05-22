include ../vars.mk


.PHONY: configure
configure:
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf
	# https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md
	~/.tmux/plugins/tpm/bin/install_plugins

.PHONY: install
install:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

