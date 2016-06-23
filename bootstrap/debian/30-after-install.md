# After install

## Add user to sudoers

```sh
$ su -c visudo
```

Add youself as superuser without password

```
# User privilege specification
root        ALL=(ALL:ALL) ALL
newuser    ALL=(ALL:ALL) NOPASSWD: ALL
```

## Fix timezone

```sh
$ sudo dpkg-reconfigure tzdata
```

## Configure wifi

```
# Find out device name
$ sudo iwconfig

# Add interface
$ sudo vi /etc/network/interfaces

iface wlan0 inet dhcp
wpa-conf /etc/network/wireless.conf

# Add networks
$ sudo vi /etc/network/wireless.conf

network={
    ssid="my network name"
    proto=RSN
    key_mgmt=WPA-PSK
    pairwise=CCMP TKIP
    group=CCMP TKIP
    psk="my password"
}

# Try
$ sudo ifdown eth0
$ sudo ifup wlan0

# Troubleshooting
$ dmesg
```

## Configure printers

```
$ sudo systemctl status cups.service
$ sudo systemctl start cups.service
```

Open http://localhost:631 and add new printer. User root user and password for basic auth.

