.PHONY: install
install:
	git clone git@github.com:agalitsyn/kickstart.nvim.git
	#nvim --headless "+Lazy! sync" +qa

.PHONY: configure
configure:
	ln -sf $(CURDIR)/custom ~/.config/nvim/lua/

.PHONY: uninstall
uninstall:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.config/nvim
	rm -rf ~/.cache/nvim

