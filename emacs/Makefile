.PHONY: install
install:
	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
	~/.config/emacs/bin/doom install
	~/.config/emacs/bin/doom sync

.PHONY: uninstall
uninstall:
	rm -rf ~/.doom.d
	rm -rf ~/.emacs.d
	rm -rf ~/.config/emacs

