# HiDPI Support For Scaled Resolutions

http://www.everymac.com/systems/apple/macbook_pro/macbook-pro-retina-display-faq/macbook-pro-retina-display-hack-to-run-native-resolution.html

Example for DELL P2416D 2560x1440

## Enable HiDPI Mode

```sh
$ sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true
```

## Detect your Display

```sh
$ ioreg -lw0 | grep IODisplayPrefsKey
    | | | |   | |   |       "IODisplayPrefsKey" = "Alias:0/AppleBacklightDisplay-610-a00e"
    | | | |   | |   |       "IODisplayPrefsKey" = "IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/P0P2@1/IOPP/GFX0@0/NVDA,Display-D@3/NVDA/display0/AppleDisplay-10ac-a0c3"
```

Since I want to set scale resolutions for my external monitor I need to look at the second line. At the end of the line we identify 10ac as DisplayVendorId and a0c3 as DisplayProductID.

## Generate PropertyList file

Open https://comsysto.github.io/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions/

## M1 proccessor

Seems that solution not works more.
* https://developer.apple.com/forums/thread/672552
* https://github.com/xzhih/one-key-hidpi/issues/164

Tried:
* SwitchResX

Try:
* https://github.com/waydabber/BetterDummy/

## OSX Big Sur

```
sudo mkdir -pv /Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac
sudo cp DisplayProductID-a0c3 /Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac
```

## OSX Calalina and older

### Disable System Integrity Protection

* Reboot the Mac and hold down Command + R keys simultaneously after you hear the startup chime, this will boot OS X into Recovery Mode
* When the “OS X Utilities” screen appears, pull down the ‘Utilities’ menu at the top of the screen instead, and choose “Terminal”
* Type the following command into the terminal then hit return:

```sh
csrutil disable
```

You’ll see a message saying that `System Integrity Protection has been disabled`

Check:
```sh
$ csrutil status
System Integrity Protection status: disabled
```

Then reboot

More see in http://osxdaily.com/2015/10/05/disable-rootless-system-integrity-protection-mac-os-x/

### Copy file to System folder

```sh
# mount root-fs
sudo mount -uw /
# copy file
sudo cp DisplayProductID-a0c3 /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac/DisplayProductID-a0c3
```

## Install Retina DisplayMenu

http://avi.alkalay.net/software/RDM/RDM-2.1.dmg or from source https://github.com/avibrazil/RDM

Add it to Login Items

## Restart and try

Now you can enable 1920x1080 HDPI mode
