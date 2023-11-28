include ../vars.mk

.PHONY: none
none:
	echo 'nothing to do'

.PHONY: configure-linux
configure-linux:
	ln -sf $(CURDIR)/Packages/User ~/.config/sublime-text/Packages/User
	ln -sf $(CURDIR)/Packages/sublime-profiles ~/.config/sublime-text/Packages/sublime-profiles

.PHONY: configure-osx
configure-osx:
	ln -sf $(CURDIR)/Packages/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
	ln -sf $(CURDIR)/Packages/sublime-profiles ~/Library/Application\ Support/Sublime\ Text/Packages/sublime-profiles

