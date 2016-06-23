#!/usr/bin/env bash

set -xe

sudo usermod -aG docker $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
