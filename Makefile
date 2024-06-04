.PHONY: essentials
essentials:
	make -C zsh
	make -C ssh
	make -C git
	make -C tmux
	make -C nvim

