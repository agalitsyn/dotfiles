UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS := linux
    PACKAGE_MNG := sudo apt-get
    INSTALL_CMD := $(PACKAGE_MNG) install --yes --no-install-recommends
endif
ifeq ($(UNAME_S),Darwin)
    OS := osx
    PACKAGE_MNG := brew
    INSTALL_CMD := $(PACKAGE_MNG) install
endif

UPDATE_CMD := $(PACKAGE_MNG) update
UPGRADE_CMD := $(PACKAGE_MNG) upgrade
