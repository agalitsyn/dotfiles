include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/goenv.sh $(BASH_HOOKS_FOLDER)/goenv.sh
	ln -sf $(CURDIR)/goenv.sh $(ZSH_HOOKS_FOLDER)/goenv.zsh

.PHONY: install
install:
	$$(bash install.sh)

PACKAGES := golang.org/x/tools/cmd/goimports \
			github.com/stamblerre/gocode \
			github.com/uudashr/gopkgs/cmd/gopkgs \
			github.com/ramya-rao-a/go-outline \
			github.com/acroca/go-symbols \
			golang.org/x/tools/cmd/guru \
			golang.org/x/tools/cmd/gorename \
			github.com/fatih/gomodifytags \
			github.com/haya14busa/goplay/cmd/goplay \
			github.com/josharian/impl \
			github.com/tylerb/gotype-live \
			github.com/rogpeppe/godef \
			github.com/zmb3/gogetdoc \
			github.com/sqs/goreturns \
			winterdrache.de/goformat/goformat \
			golang.org/x/lint/golint \
			github.com/cweill/gotests/... \
			github.com/alecthomas/gometalinter \
			honnef.co/go/tools/... \
			github.com/golangci/golangci-lint/cmd/golangci-lint \
			github.com/mgechev/revive \
			github.com/sourcegraph/go-langserver \
			golang.org/x/tools/cmd/gopls \
			github.com/go-delve/delve/cmd/dlv \
			github.com/davidrjenni/reftools/cmd/fillstruct \
			github.com/godoctor/godoctor \
			github.com/google/pprof \
			github.com/sourcegraph/go-langserver

.PHONY: packages
packages:
	$(foreach pkg,$(PACKAGES),go get -u $(pkg);)

