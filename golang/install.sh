#!/usr/bin/env bash

set -xe

function install_golang() {
	if [ -f /opt/go/bin/go ]; then
		return
	fi

	cd /tmp && curl --show-error --location "https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz" | tar --extract --gzip
	sudo mv /tmp/go $GOROOT
}

function configure_golang_env() {
	if [ -d ~/.bash.d/goenv ]; then
		return
	fi

	cat > ~/.bash.d/goenv << EOL
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOL
}

export GOVERSION=1.6.2
export GOROOT=/opt/go
export GOPATH=~/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

install_golang "1.6.2"
configure_golang_env
