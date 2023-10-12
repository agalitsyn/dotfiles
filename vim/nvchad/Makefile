.PHONY: install
install:
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

.PHONY: configure
configure:
	ln -sf $(CURDIR)/lua/custom ~/.config/nvim/lua/

.PHONY: uninstall
uninstall:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.config/nvim

