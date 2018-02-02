# Setup new thinkpad

Open BIOS using F1:
* Security - secure boot - disable
* Security - virtualization - enable
* Startup - BIOS - change from UEFI to both UEFI and legacy
* Startup - Boot devica list F12 option - enable
* Restart - OS optimised defaults - disable
* Config - keyboard - swap Fn and CTRL key - enabled
* Date/Time - fix to current

* Insert live USB
* Open boot menu F12, load from it

# Debian live USB

* Download [debian live iso](https://www.debian.org/CD/live/)
* Dump it on USB flash

```sh
$ diskutil list # on OSX
$ sudo dd if=debian-live-8.5.0-amd64-standard.iso of=/dev/disk2
```

*Note*: `unetbootin` breaks loader, don't use it.

## Partitioning

```
$ cat /etc/fstab

LABEL=ROOT / btrfs    discard,noatime,nodiratime 0       1
```
