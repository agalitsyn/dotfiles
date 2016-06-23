#!/usr/bin/env bash

virsh net-autostart default
virsh net-start default
virsh net-list --all

sudo systemctl status libvirtd
