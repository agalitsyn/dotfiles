include ../vars.mk

.PHONY: configure
configure:
	ln -sf $(CURDIR)/goenv.sh $(ZSH_HOOKS_FOLDER)/goenv.zsh

PACKAGES := golang.org/x/tools/cmd/goimports \
			github.com/golangci/golangci-lint/v2/cmd/golangci-lint \
			mvdan.cc/gofumpt \
			github.com/segmentio/golines \
			golang.org/x/tools/gopls \
			github.com/go-delve/delve/cmd/dlv

.PHONY: install-packages
install-packages:
	$(foreach pkg,$(PACKAGES),go install $(pkg)@latest;)

