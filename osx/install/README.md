# Installing new Mac

## Trackpad

- Uncheck "natural scrolling"
- Accessability - Pointer control - Trackpad - Enable "Three fingers drag"

## Dock

- Desktop and Dock
    - Position - left
    - Hide desktop items
    - Mission control
        - Uncheck "automatically rearrange spaces"

## Keyboard

- Increase repeat rate and delay
- Text input - Input sources - Add "Russian PC"
- Keyboard - Shortcuts
    - Modifier keys - Caps lock = Escape
    - Mission control ctrl+opt+left right = move to space;
    - Services - disable all

### External keyboard types § instead of backtick

macOS records a per-device keyboard *type* (ANSI/ISO/JIS) in
`/Library/Preferences/com.apple.keyboardtype.plist`, separate from the input
source. A board flagged ISO gets HID usages `0x35` (Grave/Tilde) and `0x64`
(Non-US `\`) swapped, so an ANSI keyboard's grave key produces § and ctrl+grave
arrives as ctrl+§. The layout ("U.S.") is not involved and changing it does not
help.

The GUI that writes this value is Keyboard Setup Assistant, at
`/System/Library/CoreServices/KeyboardSetupAssistant.app`. It asks you to press
keys adjacent to Shift, and answering wrong flags an ANSI board as ISO.

It cannot be used to fix a wrong answer:

- It only appears automatically for a keyboard with no entry in the plist, so
  once any value is recorded the trigger is permanently false. Launching it by
  hand just reports the keyboard as already identified.
- System Settings has no button to re-run it. Older macOS had "Change Keyboard
  Type…" under System Preferences > Keyboard; that is gone (verified absent from
  `KeyboardSettings.appex`, `KeyboardSettingsIntents.appex` and
  `Keyboard.prefPane` on 15.7.8).
- Getting the dialog back means deleting the device's entry from a root-owned
  plist first, which needs the terminal anyway.

So correcting it is terminal-only:

```sh
./setup-keyboard-type.sh devices   # connected keyboards + the plist identifier keys
./setup-keyboard-type.sh fix       # correct the type, plus a stopgap HID remap
# reboot — WindowServer only reads the keyboard type at boot
```

Beware when touching the device's `UserKeyMapping` HID property by hand: it is
not where System Settings > Keyboard > Modifier Keys stores its remaps, so
re-adding those entries there applies them twice, and a double Option<->Command
swap cancels itself out and kills every cmd+<key> shortcut. See the script
header.

## Upgrade Mac OS

Probably to latest

## Disable Airplay receiver (consumes ports 5000 and 7000)

System Settings -> General -> Airdrop & Handoff -> Airplay receiver

## Install software

Type `git` and follow installation guide for xcode cli tools.

Then clone dotfiles and install everything with homebrew and link configs.

## Login into accounts for transfering data

- iCloud
- Yandex Disk (choose what to sync)
- Firefox
- Chrome

## Transfer sensitive data

- SSH keys
- Raycast settings

## Security

- Enable Firewall
- Enable FireVault

## Prevent disconnecting VPNs on screen lock

- Battery - Options - Prevent automatic sleeping

## Spotlight

- Siri and Spotlight ->  Remove all items from Spotlight index, especially PDF to avoid `CGPDFService` high CPU usage

Disable spotlight completly:
- Restart in Recovery mode (hold power button)
- Open terminal and run `csrutil disable`
- Restart

- Disable spotlight on all disks `sudo mdutil -a -i off`
- Unload service `sudo launchctl bootout gui/$UID /System/Library/LaunchDaemons/com.apple.metadata.mds.plist`
- Restart

## Dock

Speed up animation speed

```sh
defaults write com.apple.dock autohide-time-modifier -float 0; killall Dock
```

Show app switcher on all desktops

```
defaults write com.apple.dock appswitcher-all-displays -bool true && killall Dock
```

## Apple intelligence

System Settings -> Apple Intelligence and Siri -> Disable

About Siri ... -> Disable all

## Facetime

Open Facetime -> Settings -> Disable calls from iPhone

