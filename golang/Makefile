include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/goenv.sh $(ZSH_HOOKS_FOLDER)/goenv.zsh

PACKAGES := golang.org/x/tools/cmd/goimports \
			github.com/incu6us/goimports-reviser/v3 \
			mvdan.cc/gofumpt \
			github.com/segmentio/golines \
			github.com/golangci/golangci-lint/cmd/golangci-lint \
			golang.org/x/tools/cmd/gopls \
			github.com/go-delve/delve/cmd/dlv

.PHONY: install
install:
	$(foreach pkg,$(PACKAGES),go install $(pkg)@latest;)

