#!/usr/bin/env bash

set -xe

# Env
GOVERSION=${GOVERSION:-"1.7.3"}

# Constants
GOROOT="/opt/google/golang/$GOVERSION"
GOPATH="$PROJECTS"
GOARCH="amd64"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    GOOS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    GOOS="darwin"
fi

function install_golang() {
	if [ -f $GOROOT/bin/go ]; then
		return
	fi

	sudo mkdir -pv $GOROOT
	cd /tmp && curl --show-error --location "https://storage.googleapis.com/golang/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz" | tar --extract --gzip
	sudo mv /tmp/go/* $GOROOT
	rm -r /tmp/go
}

function configure_golang_env() {
	cat > ~/.bash.d/goenv.sh << EOL
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOL
}

function main() {
	install_golang
	configure_golang_env
}

main
