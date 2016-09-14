include globals.mk

.PHONY: all
all:
	echo "Pick up manually what configs you want"

.PHONY: update
update:
	$(UPDATE_CMD)

.PHONY: upgrade
upgrade:
	$(UPGRADE_CMD)
