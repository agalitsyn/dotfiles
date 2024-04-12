.PHONY: install
install:
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim/.git

.PHONY: configure
configure:
	ln -sf $(CURDIR)/nvim ~/.config/nvim

.PHONY: uninstall
uninstall:
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim

