#!/bin/bash
#
# Record per-device modifier key remaps — the Option<->Command swap and
# Caps Lock -> Escape that a PC-layout external keyboard needs — the same way
# System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys does.
#
# The setting lives in a ByHost preference in NSGlobalDomain, one key per
# device, holding an array of Src/Dst HID usage pairs:
#
#   com.apple.keyboard.modifiermapping.<VendorID>-<ProductID>-<CountryCode>
#     ( { HIDKeyboardModifierMappingSrc = 30064771129;
#         HIDKeyboardModifierMappingDst = 30064771113; } )   # caps lock -> escape
#
# Being ByHost (~/Library/Preferences/ByHost/) it is per-machine and does not
# follow the account to a new Mac, which is exactly why it belongs in here.
#
# Usage values are `page << 32 | usage`. Every modifier of interest is on page
# 0x07 (Keyboard/Keypad), so the base is 0x700000000 = 30064771072 and e.g.
# Caps Lock (0x39) is 30064771129, Escape (0x29) is 30064771113.
#
# CAVEAT 1 — the identifier order is the REVERSE of the one in
# setup-keyboard-type.sh. This file keys on <Vendor>-<Product>, that one keys on
# <Product>-<Vendor>, for the same physical keyboard:
#
#   keyboardtype     64007-13652-0    (product-vendor)
#   modifiermapping  13652-64007-0    (vendor-product)
#
# Getting it backwards writes a key macOS never reads, and the whole thing
# silently does nothing. `status` prints the key it actually used, so check it.
#
# CAVEAT 2 — this is only macOS's *record* of the setting. It is NOT applied via
# the device's UserKeyMapping HID property, and writing it there instead is a
# trap documented at length in setup-keyboard-type.sh: the two stack, and a
# double Option<->Command swap cancels out and kills every cmd+<key> shortcut.
# macOS applies these further up the stack, at login and on device attach, so a
# freshly written value needs a logout (or re-attaching the keyboard) to take
# effect. Nothing here takes effect immediately.
#
# CAVEAT 3 — identity pairs (Src == Dst) are no-ops. The Modifier Keys dialog
# sometimes writes them for untouched rows and sometimes does not, so the lists
# below omit them and `status` filters them out before comparing. A device
# showing only identity pairs has been *registered* but not actually remapped.
#
# Capturing a board configured through the GUI: set it up in System Settings,
# then run `./setup-modifier-keys.sh capture` and paste the line it prints into
# DEVICES below.

set -euo pipefail

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || exit 1

# Devices to configure, as
#   "<VendorID>-<ProductID>-<CountryCode>|<label>|<src>:<dst>,<src>:<dst>,..."
# using the key names from usage_for() below. Order within a line is irrelevant.
#
# Both boards get the same treatment: they are PC-layout keyboards, so the key
# physically where a Mac puts Command is Alt and has to be swapped, and Caps
# Lock is wasted space. The internal MacBook keyboard is deliberately absent —
# it only wants Caps Lock -> Escape, and it already has it.
SWAP_AND_ESCAPE='caps_lock:escape,left_option:left_command,left_command:left_option,right_option:right_command,right_command:right_option'
DEVICES=(
    "13652-64007-0|AULA-F75 5.0 KB, Bluetooth LE|$SWAP_AND_ESCAPE"
    "9610-268-0|Gaming Keyboard, BY Tech, USB|$SWAP_AND_ESCAPE"
)

DOMAIN=com.apple.keyboard.modifiermapping

# HID usage id for a modifier key name, as the integer these plists store.
#
# A case rather than an associative array because /bin/bash on macOS is still
# 3.2, which has no `declare -A`.
#
# Globe/fn is intentionally absent: it sits on the AppleVendor Top Case page
# (0xff), not 0x07, so it does not follow the arithmetic below, and nothing here
# needs to remap it.
usage_for() {
    local base=30064771072 # 0x700000000, page 0x07 Keyboard/Keypad
    local usage
    case "$1" in
    escape) usage=41 ;;        # 0x29
    caps_lock) usage=57 ;;     # 0x39
    left_control) usage=224 ;; # 0xe0
    left_shift) usage=225 ;;   # 0xe1
    left_option) usage=226 ;;  # 0xe2
    left_command) usage=227 ;; # 0xe3
    right_control) usage=228 ;;
    right_shift) usage=229 ;;
    right_option) usage=230 ;;
    right_command) usage=231 ;;
    *)
        echo >&2 "unknown modifier key '$1'"
        return 1
        ;;
    esac
    echo $((base + usage))
}

# Inverse of usage_for, for printing recorded values back as names.
name_for() {
    case $(($1 - 30064771072)) in
    41) echo escape ;;
    57) echo caps_lock ;;
    224) echo left_control ;;
    225) echo left_shift ;;
    226) echo left_option ;;
    227) echo left_command ;;
    228) echo right_control ;;
    229) echo right_shift ;;
    230) echo right_option ;;
    231) echo right_command ;;
    *) echo "usage:$1" ;;
    esac
}

# The recorded pairs for a device key, one "<src>:<dst>" per line, as names,
# with identity pairs dropped and the result sorted so it can be compared
# against a DEVICES line regardless of the order macOS chose to write.
recorded_pairs() {
    local src dst
    defaults -currentHost read -g "$DOMAIN.$1" 2>/dev/null |
        tr -d ' ;' | grep -oE 'HIDKeyboardModifierMapping(Src|Dst)=[0-9]+' |
        cut -d= -f2 | while read -r dst && read -r src; do
        # defaults prints Dst before Src within each dict, hence the read order.
        [ "$src" = "$dst" ] || echo "$(name_for "$src"):$(name_for "$dst")"
    done | sort
}

# The desired pairs from a DEVICES spec, normalised the same way.
wanted_pairs() {
    echo "$1" | tr ',' '\n' | sort
}

apply() {
    local entry id label spec pair src dst plist
    for entry in "${DEVICES[@]}"; do
        IFS='|' read -r id label spec <<<"$entry"
        plist="("
        for pair in $(echo "$spec" | tr ',' ' '); do
            src=$(usage_for "${pair%%:*}")
            dst=$(usage_for "${pair##*:}")
            plist+="{HIDKeyboardModifierMappingSrc=$src;HIDKeyboardModifierMappingDst=$dst;},"
        done
        plist="${plist%,})"
        echo "writing $DOMAIN.$id  ($label)"
        defaults -currentHost write -g "$DOMAIN.$id" "$plist"
    done
    echo
    echo "log out and back in (or re-attach the keyboard) — macOS reads these at"
    echo "login and on device attach, not on write"
}

clear_all() {
    local entry id label spec
    for entry in "${DEVICES[@]}"; do
        IFS='|' read -r id label spec <<<"$entry"
        echo "clearing $DOMAIN.$id ($label)"
        defaults -currentHost delete -g "$DOMAIN.$id" 2>/dev/null ||
            echo "  (nothing recorded)"
    done
    echo
    echo "log out and back in for this to take effect"
}

status() {
    local entry id label spec have want
    for entry in "${DEVICES[@]}"; do
        IFS='|' read -r id label spec <<<"$entry"
        echo "=== $label ==="
        echo "  key $DOMAIN.$id"
        have=$(recorded_pairs "$id")
        want=$(wanted_pairs "$spec")
        if [ -z "$have" ]; then
            echo "  recorded: nothing (or identity pairs only — registered, not remapped)"
        else
            echo "  recorded:"
            echo "$have" | sed 's/^/    /'
        fi
        if [ "$have" = "$want" ]; then
            echo "  MATCHES this script"
        else
            echo "  DIFFERS from this script, which wants:"
            echo "$want" | sed 's/^/    /'
        fi
    done
}

# Print a DEVICES line for every device macOS has a non-identity mapping for, so
# a board configured through the GUI can be pasted straight into the list above.
capture() {
    local id pairs
    for id in $(defaults -currentHost read -g 2>/dev/null |
        grep -oE "$DOMAIN\.[0-9]+-[0-9]+-[0-9]+" | sed "s/$DOMAIN\.//" | sort -u); do
        pairs=$(recorded_pairs "$id" | paste -sd, -)
        [ -n "$pairs" ] || continue
        echo "    \"$id|TODO label|$pairs\""
    done
}

case "${1:-}" in
apply) apply ;;
status) status ;;
clear) clear_all ;;
capture) capture ;;
*)
    echo "usage: $0 {apply|status|clear|capture}"
    echo
    echo "  apply    write the mappings in DEVICES to ByHost user defaults"
    echo "  status   compare what is recorded against what this script wants"
    echo "  clear    delete the recorded mapping for every device in DEVICES"
    echo "  capture  print DEVICES lines for every remapped device on this Mac"
    exit 1
    ;;
esac
