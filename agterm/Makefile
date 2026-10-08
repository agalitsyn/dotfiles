include ../vars.mk

# two-agent-chat cookbook recipe
PEER_CHAT_REV := master
PEER_CHAT_URL := https://raw.githubusercontent.com/umputun/agterm/$(PEER_CHAT_REV)/cookbook/two-agent-chat/peer-chat.py

.PHONY: configure
configure: peer-chat
	ln -sf $(CURDIR)/agterm.sh $(ZSH_HOOKS_FOLDER)/agterm.zsh
	mkdir -pv ~/.config/agterm
	ln -sf $(CURDIR)/keymap.conf ~/.config/agterm/keymap.conf
	ln -sf $(CURDIR)/ghostty.conf ~/.config/agterm/ghostty.conf
	ln -sf $(CURDIR)/agterm-notify.sh ~/.config/agterm/agterm-notify.sh

.PHONY: peer-chat
peer-chat:
	mkdir -pv ~/bin
	curl -fsSL -o ~/bin/peer-chat.py.tmp $(PEER_CHAT_URL)
	chmod +x ~/bin/peer-chat.py.tmp
	mv -f ~/bin/peer-chat.py.tmp ~/bin/peer-chat.py

