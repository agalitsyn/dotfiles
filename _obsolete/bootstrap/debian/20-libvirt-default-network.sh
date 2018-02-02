#!/usr/bin/env bash

set -xe

sudo systemctl status libvirtd
sudo systemctl status libvirt-guests
sudo systemctl status dnsmasq

virsh net-autostart default
virsh net-start default

virsh list --all
virsh net-list --all
virsh net-dhcp-leases default

cat >&1 <<EOT
Recommendations:

# /etc/libvirt/qemu.conf

security_driver = "none"

# /etc/init.d/libvirt-guests

ON_SHUTDOWN=suspend
EOT
