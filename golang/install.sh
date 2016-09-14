#!/usr/bin/env bash

set -xe

# Folder which may contains different golang versions
GOFOLDER="/opt/google/golang"

# Env
export GOVERSION=${GOVERSION:-"1.7"}

# Exports
export GOROOT="$GOFOLDER/$GOVERSION"
export GOPATH="$PROJECTS/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

function install_golang() {
	if [ -f $GOROOT/bin/go ]; then
		return
	fi

	cd /tmp && curl --show-error --location "https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz" | tar --extract --gzip
	sudo mv /tmp/go $GOROOT
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
