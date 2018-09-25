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

* Download [linux mint live iso](https://linuxmint.com/edition.php?id=254)
* Create live USB

Use https://etcher.io/

Or manually:

```sh
$ diskutil list # on OSX
$ sudo dd if=debian-live-8.5.0-amd64-standard.iso of=/dev/disk2
```

*Note*: popular tool `unetbootin` breaks loader, don't use it.

## Partitioning

Notes:

* add swap
* use `ext4`

```
$ cat /etc/fstab

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
UUID=7c06ef97-d7b3-4563-933a-7599059760d1       /               ext4    errors=remount-ro,discard,noatime    0       1
/swapfile                                       none            swap    sw                                   0       0
```
