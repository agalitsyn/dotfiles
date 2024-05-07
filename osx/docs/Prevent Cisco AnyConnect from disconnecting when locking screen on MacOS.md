## TL;DR
Launch Terminal and run:

`ifconfig | grep -B 6 'status: active' | head -n 1 | cut -d : -f 1`

Then run (replace en0 below with the output of the command above):

```
cd /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources
sudo ./airport en0 prefs DisconnectOnLogout=NO
sudo pmset -a sleep 0
```

## Long version
I am on MacOS Mojave (10.14).
For me this helped against automatically disconnecting from Cisco AnyConnect while on WiFi:

Open the Terminal app and paste:

`ifconfig | grep -B 6 'status: active' | head -n 1 | cut -d : -f 1`

This returned:

`en0`

Then type (replace `en0` on line 2 with the returned value above):

```
cd /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources
sudo ./airport en0 prefs DisconnectOnLogout=NO
```

Type your password.

Check if the setting was saved by typing:

`sudo ./airport prefs`

Which should return this:

AirPort preferences for `en0`:

```
DisconnectOnLogout=NO
Unable to retrieve JoinMode
JoinModeFallback=DoNothing
RememberRecentNetworks=YES
RequireAdminIBSS=NO
RequireAdminNetworkChange=NO
RequireAdminPowerToggle=NO
WoWEnabled=YES
DisconnectOnLogout should be set to NO.
```

Next, prevent the system from going to sleep after locking:

`sudo pmset -a sleep 0`

That should do the trick, worked for me.

---

https://apple.stackexchange.com/a/338617