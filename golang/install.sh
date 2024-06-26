#!/usr/bin/env bash
#
# Use for manage multiple Go versions

set -xe

# Env
GOVERSION=${GOVERSION:-"1.14.7"}
GODIR=${GODIR:-"/opt/golang/go"}

# Constants
GOROOT="$GODIR/$GOVERSION"
GOPATH="~"
GOARCH="amd64"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    GOOS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    GOOS="darwin"
fi

function install_golang() {
    if [ -f "$GOROOT/bin/go" ]; then
        return
    fi

    sudo mkdir -pv "$GOROOT"
    cd /tmp && curl --show-error --location "https://storage.googleapis.com/golang/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz" | tar --extract --gzip
    sudo mv /tmp/go/* "$GOROOT"
    rm -r /tmp/go
}

function configure_golang_env() {
    cat >~/.zsh.d/goenv.zsh <<EOL
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
EOL
}

function main() {
    install_golang
    configure_golang_env
}

main
