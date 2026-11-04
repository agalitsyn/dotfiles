include ../vars.mk

# two-agent-chat cookbook recipe
PEER_CHAT_REV := master
PEER_CHAT_URL := https://raw.githubusercontent.com/umputun/agterm/$(PEER_CHAT_REV)/cookbook/two-agent-chat/peer-chat.py

# named-companion + session-context-nudge cookbook recipes, pinned to the commit they were reviewed at
COOKBOOK_REV := aa13e2f95f707048b206aaf3823519205927536a
COOKBOOK_URL := https://raw.githubusercontent.com/umputun/agterm/$(COOKBOOK_REV)/cookbook

.PHONY: configure
configure: peer-chat companion
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

.PHONY: companion
companion:
	mkdir -pv ~/bin
	curl -fsSL -o ~/bin/companion.py.tmp $(COOKBOOK_URL)/named-companion/companion.py
	curl -fsSL -o ~/bin/context-nudge.sh.tmp $(COOKBOOK_URL)/session-context-nudge/context-nudge.sh
	chmod +x ~/bin/companion.py.tmp ~/bin/context-nudge.sh.tmp
	mv -f ~/bin/companion.py.tmp ~/bin/companion.py
	mv -f ~/bin/context-nudge.sh.tmp ~/bin/context-nudge.sh

