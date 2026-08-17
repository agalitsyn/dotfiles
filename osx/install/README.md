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
    - Modifier keys - Caps lock = Escape (scripted, see below)
    - Mission control ctrl+opt+left right = move to space;
    - Services - disable all

### Per-device modifier keys (Option<->Command swap, Caps Lock -> Escape)

Modifier Keys is a *per-keyboard* setting, so every external board needs it set
again, and it is stored ByHost
(`~/Library/Preferences/ByHost/`, key
`com.apple.keyboard.modifiermapping.<VendorID>-<ProductID>-<CountryCode>` in
NSGlobalDomain) — per-machine, and not carried over to a new Mac. That is what
`setup-modifier-keys.sh` captures:

```sh
./setup-modifier-keys.sh status    # recorded vs. what the script wants
./setup-modifier-keys.sh apply     # write them
./setup-modifier-keys.sh capture   # dump every remapped board as config lines
# log out and back in — macOS reads these at login and on device attach
```

PC-layout boards get the same treatment: Option<->Command swapped both sides (the
key physically where a Mac puts Command is Alt) plus Caps Lock -> Escape.
Currently covered: the AULA-F75 over Bluetooth and the BY Tech "Gaming Keyboard"
over USB. The internal keyboard is left out — it only wants Caps Lock -> Escape
and already has it.

The workflow for a new board is to set it up in System Settings once, then run
`capture` and paste the line it prints into `DEVICES`.

Two things to know:

- The identifier order is the **reverse** of the keyboard-type plist's:
  `modifiermapping` keys on `<Vendor>-<Product>`, `keyboardtype` on
  `<Product>-<Vendor>`. Same keyboard, e.g. `13652-64007-0` vs `64007-13652-0`.
  Getting it backwards writes a key macOS never reads and silently does nothing.
- Identity pairs (Src == Dst) are no-ops. The GUI writes them for some untouched
  rows and not others, so the script omits them and `status` filters them out
  before comparing. A device with *only* identity pairs has been registered but
  not actually remapped.

Do not try to apply these through the device's `UserKeyMapping` HID property —
see the warning in the next section.

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

### Shortcuts for menu items that ship without one

Any menu item can be bound by writing a per-app `NSUserKeyEquivalents` dict,
which is what System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts
edits. `setup-app-shortcuts.sh` holds the list and writes it:

```sh
./setup-app-shortcuts.sh status   # recorded shortcuts + the live menu bar
./setup-app-shortcuts.sh apply    # write them
./setup-app-shortcuts.sh clear    # drop them all
```

Currently bound: shift+cmd+l toggles Safari's sidebar. Safari 26 dropped the
binding it had through Safari 14 — `View > Show Sidebar` has no key equivalent
at all now, so this restores the old one rather than overriding anything.

Three things bite when adding more:

- Titles are matched literally in the current UI language, and these menus
  render in en-GB ("Minimise", "Show Favourites Bar", "Centre"), so titles
  copied from US screenshots will silently fail to match.
- A toggling item renames itself and needs an entry per name — "Show Sidebar"
  *and* "Hide Sidebar".
- AppKit reads the dict only while building the menu bar, so the app has to be
  relaunched before the shortcut appears.

`status` dumps the live menu bar through the Accessibility API, which is the way
to get a title exactly right and to check a combo is free before taking it. It
needs Accessibility permission granted to the terminal, and it can only read an
app that is running.

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

