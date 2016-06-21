#!/usr/bin/env bash

function install_golang() {
	if [ -f /opt/go/bin/go ]; then
		return
	fi

	local version=${1:-"1.5.4"}

	announce_step "Installing Go $version"
	cd /tmp && curl --silent --show-error --location "https://storage.googleapis.com/golang/go${version}.linux-amd64.tar.gz" | tar --extract --gzip
	sudo mv /tmp/go $GOROOT

}

function configure_golang_env() {
	if grep --quiet GOPATH ~/.bashrc; then
		return
	fi

	announce_step 'Configure Go environment variables'
	echo "export GOROOT=$GOROOT" >> ~/.bashrc
	echo "export GOPATH=$GOPATH" >> ~/.bashrc
	echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
}


install_golang "1.6.2"
configure_golang_env
echo 'Done'
