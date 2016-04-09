include globals.mk

update:
	$(UPDATE_CMD)

upgrade:
	$(UPGRADE_CMD)

install: update
	$(MAKE) -C nvim install

configure:
	$(MAKE) -C nvim configure
