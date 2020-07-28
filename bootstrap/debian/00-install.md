# Debian live USB

* Download debian
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
