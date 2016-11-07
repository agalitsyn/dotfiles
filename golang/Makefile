GOVERSION ?= 1.7.3

CODE_INTELLIGENCE_PACKAGES := \
	golang.org/x/tools/cmd/goimports \
	github.com/nsf/gocode \
	github.com/rogpeppe/godef \
	github.com/golang/lint/golint \
	github.com/lukehoban/go-outline \
	sourcegraph.com/sqs/goreturns \
	golang.org/x/tools/cmd/gorename \
	github.com/tpng/gopkgs \
	github.com/newhook/go-symbols \
	golang.org/x/tools/cmd/guru

DEV_TOOLS := \
	github.com/mattn/goreman \
	github.com/tools/godep \
	github.com/kardianos/govendor \
	github.com/Masterminds/glide \
	github.com/alecthomas/gometalinter \
	github.com/warmans/golocc \
	github.com/divan/depscheck

.PHONY: all
all: install packages

.PHONY: packages
packages:
	$(foreach pkg,$(CODE_INTELLIGENCE_PACKAGES),go get -u -v $(pkg);)
	$(foreach pkg,$(DEV_TOOLS),go get -u -v $(pkg);)
	gometalinter --install --update

.PHONY: install
install:
	$$(GOVERSION=$(GOVERSION) bash install.sh)
