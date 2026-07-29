#!/bin/bash
#
# Fix an external ANSI keyboard that types § instead of ` (and ± instead of ~),
# so ctrl+` reaches apps as ctrl+§.
#
# macOS keeps a per-device keyboard *type* in
# /Library/Preferences/com.apple.keyboardtype.plist, keyed by
# "<ProductID>-<VendorID>-<CountryCode>", with 40=ANSI, 41=ISO, 42=JIS.
# It is recorded once by Keyboard Setup Assistant, which asks you to press the
# key next to left Shift — answer wrong and the board is flagged ISO for good.
#
# When a keyboard is flagged ISO, macOS swaps HID usages 0x35 (Grave/Tilde) and
# 0x64 (Non-US \ and |) while translating to virtual keycodes:
#
#   ANSI: usage 0x35 -> keycode 50 (`)      ISO: usage 0x35 -> keycode 10 (§)
#
# An ANSI board only ever sends 0x35, so the grave key comes out as §.
#
# This is unrelated to the input source / layout — "U.S." is already correct.
#
# Inspect current state:
#   plutil -p /Library/Preferences/com.apple.keyboardtype.plist
#   ioreg -c IOHIDDevice -r -d 1 | grep -E '"(Product|VendorID|ProductID)"'

set -euo pipefail

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || exit 1

# Keyboards to force to ANSI, as "<ProductID>-<VendorID>-<CountryCode>".
# 268-9610-0 = "Gaming Keyboard", SINOWEALTH (0x258a)
KEYBOARDS=(
    "268-9610-0"
)

PLIST=/Library/Preferences/com.apple.keyboardtype
ANSI=40
ISO=41

GRAVE_USAGE=0x700000035  # Keyboard Grave Accent and Tilde
NON_US_USAGE=0x700000064 # Keyboard Non-US \ and |

current_type() {
    /usr/libexec/PlistBuddy -c "Print :keyboardtype:${1}" "$PLIST.plist" 2>/dev/null || true
}

# CAUTION: System Settings > Keyboard > Modifier Keys stores its per-device
# remaps as HIDKeyboardModifierMappingSrc/Dst pairs in
#   com.apple.keyboard.modifiermapping.<VendorID>-<ProductID>-<CountryCode>
# (note: vendor-product, the reverse of the keyboardtype plist's key order)
# and applies them by writing the device's *UserKeyMapping* HID property —
# the very same property hidutil sets. A bare `hidutil --set UserKeyMapping`
# therefore silently wipes your Caps Lock -> Escape and Option/Command swap.
#
# So always build the full set: macOS's stored modifier remaps *plus* whatever
# we are adding. Emits the JSON hidutil wants on stdout.
build_mapping() {
    local vendor=$1 product=$2 country=$3 with_grave=$4
    defaults -currentHost export -g - | python3 -c '
import sys, plistlib, json
vendor, product, country, with_grave, grave, non_us = sys.argv[1:7]
d = plistlib.loads(sys.stdin.buffer.read())
key = f"com.apple.keyboard.modifiermapping.{vendor}-{product}-{country}"
entries = [dict(e) for e in d.get(key, [])]
if with_grave == "1":
    entries += [
        {"HIDKeyboardModifierMappingSrc": int(grave, 16), "HIDKeyboardModifierMappingDst": int(non_us, 16)},
        {"HIDKeyboardModifierMappingSrc": int(non_us, 16), "HIDKeyboardModifierMappingDst": int(grave, 16)},
    ]
print(json.dumps({"UserKeyMapping": entries}))
' "$vendor" "$product" "$country" "$with_grave" "$GRAVE_USAGE" "$NON_US_USAGE"
}

# Pre-compensate for the ISO swap at the HID layer. Takes effect immediately,
# but is bound to the device's registry entries: it is lost on unplug and on
# reboot (macOS then re-applies its modifier remaps alone). Use it to get a
# working ` before the reboot that `persist` needs.
remap() {
    local kb product vendor country
    for kb in "${KEYBOARDS[@]}"; do
        IFS=- read -r product vendor country <<<"$kb"
        echo "remapping $kb (vendor $vendor, product $product) + preserving modifier remaps"
        hidutil property \
            --matching "{\"VendorID\":$vendor,\"ProductID\":$product}" \
            --set "$(build_mapping "$vendor" "$product" "$country" 1)" >/dev/null
    done
}

# Drop our grave swap while leaving the Modifier Keys remaps in place. Run
# after `persist` + reboot, or if the swap ever lands the wrong way round.
unmap() {
    local kb product vendor country
    for kb in "${KEYBOARDS[@]}"; do
        IFS=- read -r product vendor country <<<"$kb"
        echo "restoring $kb to modifier remaps only"
        hidutil property \
            --matching "{\"VendorID\":$vendor,\"ProductID\":$product}" \
            --set "$(build_mapping "$vendor" "$product" "$country" 0)" >/dev/null
    done
}

# Correct the recorded keyboard type. Read by WindowServer at boot, so this
# needs a reboot to take effect. Refuses to touch anything not currently
# flagged ISO, so re-running is safe and a genuinely-ISO board is left alone.
persist() {
    local kb type
    for kb in "${KEYBOARDS[@]}"; do
        type=$(current_type "$kb")
        if [ "$type" = "$ANSI" ]; then
            echo "$kb already ANSI, skipping"
            continue
        fi
        if [ "$type" != "$ISO" ]; then
            echo >&2 "$kb is '${type:-unset}', expected $ISO (ISO) — skipping, check by hand"
            continue
        fi
        echo "setting $kb to ANSI ($ANSI), was ISO ($ISO)"
        sudo defaults write "$PLIST" keyboardtype -dict-add "$kb" -int "$ANSI"
    done
    echo "reboot for this to take effect; the HID remap from \`remap\` does not"
    echo "survive a reboot, so nothing needs undoing afterwards"
}

# List connected keyboards with the identifier keys both plists use, so you can
# fill in KEYBOARDS above on a new machine or for a new board.
#
# Keyboards are the IOHIDDevice nodes with PrimaryUsagePage 1 (Generic Desktop)
# and PrimaryUsage 6 (Keyboard). A board publishes several interfaces and they
# can disagree on CountryCode — the internal MacBook keyboard reports 13 on its
# keyboard interface while macOS still keys its prefs on 0 — so try every
# CountryCode the device reports and mark which candidates are actually recorded.
devices() {
    KEYBOARD_TYPE_PLIST="$PLIST.plist" python3 <<'PY'
import os, plistlib, subprocess

types = {}
try:
    with open(os.environ['KEYBOARD_TYPE_PLIST'], 'rb') as f:
        types = plistlib.load(f).get('keyboardtype', {})
except OSError:
    pass

def export(*cmd):
    return plistlib.loads(subprocess.run(cmd, capture_output=True, check=True).stdout)

byhost = export('defaults', '-currentHost', 'export', '-g', '-')
nodes = export('ioreg', '-c', 'IOHIDDevice', '-r', '-a', '-d', '1')

labels = {40: 'ANSI', 41: 'ISO', 42: 'JIS'}
boards, countries = {}, {}
for d in nodes:
    ids = (d.get('VendorID'), d.get('ProductID'))
    if None in ids:
        continue
    countries.setdefault(ids, set()).add(d.get('CountryCode', 0))
    if (d.get('PrimaryUsagePage'), d.get('PrimaryUsage')) == (1, 6):
        boards.setdefault(ids, d)

for (vendor, product), d in boards.items():
    print('{} by {} over {}'.format(
        d.get('Product'), d.get('Manufacturer'), d.get('Transport')))
    for country in sorted(countries[(vendor, product)] | {0}):
        kt = '{}-{}-{}'.format(product, vendor, country)
        mm = '{}-{}-{}'.format(vendor, product, country)
        recorded = types.get(kt)
        print('  keyboardtype    {:<18} = {} ({}){}'.format(
            kt, recorded, labels.get(recorded, 'unset'),
            '  <-- recorded' if recorded is not None else ''))
        print('  modifiermapping {:<18}   {}'.format(
            mm,
            '<-- recorded' if 'com.apple.keyboard.modifiermapping.' + mm in byhost else ''))
PY
}

status() {
    local kb
    devices
    echo
    echo "recorded keyboard types:"
    plutil -p "$PLIST.plist"
    for kb in "${KEYBOARDS[@]}"; do
        IFS=- read -r product vendor _ <<<"$kb"
        echo "active HID remap for $kb:"
        hidutil property \
            --matching "{\"VendorID\":$vendor,\"ProductID\":$product}" \
            --get "UserKeyMapping"
    done
}

case "${1:-}" in
devices) devices ;;
remap) remap ;;
unmap) unmap ;;
persist) persist ;;
status) status ;;
fix)
    remap
    persist
    ;;
*)
    echo "usage: $0 {fix|devices|remap|unmap|persist|status}"
    echo
    echo "  fix      remap + persist (what you want on a fresh machine)"
    echo "  devices  list connected keyboards and their plist identifier keys"
    echo "  remap    HID-level workaround, immediate, lost on unplug/reboot"
    echo "  unmap    drop the HID remap"
    echo "  persist  correct the recorded keyboard type, needs a reboot"
    echo "  status   show recorded types and active remaps"
    exit 1
    ;;
esac
