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

## Apple intelligence

System Settings -> Apple Intelligence and Siri -> Disable

About Siri ... -> Disable all

