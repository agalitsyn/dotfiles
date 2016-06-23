#!/usr/bin/env bash

set -xe

apt-get install --verbose-versions --yes --no-install-recommends --target-release, jessie-backports \
	linux-image-amd64 \
	linux-headers-amd64 \
	dkms \
	virtualbox \
	xserver-xorg-video-intel \
	firmware-linux-free \
	firmware-linux-nonfree \
	firmware-iwlwifi \
	firmware-realtek \
	intel-microcode

