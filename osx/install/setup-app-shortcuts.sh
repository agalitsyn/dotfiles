#!/bin/bash
#
# Bind keyboard shortcuts to menu items that ship without one, the same way
# System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts does.
#
# The mechanism is a per-app `NSUserKeyEquivalents` dictionary in user defaults,
# mapping a menu item's *displayed title* to a shortcut string. AppKit reads it
# while building the menu bar, so it works for any app, including ones with no
# scripting support:
#
#   NSUserKeyEquivalents = { "Show Sidebar" = "@$l"; };
#
# Shortcut string encoding (order does not matter, the key comes last):
#
#   @ = Command    ~ = Option    ^ = Control    $ = Shift
#
# Use the lowercase letter and spell Shift as `$` — "@$l", not "@L". The
# uppercase form is accepted inconsistently and shows up blank in System
# Settings.
#
# CAVEAT 1 — titles are matched literally, in the current UI language. This Mac
# renders Safari's menus in en-GB ("Minimise", "Show Favourites Bar", "Centre"),
# so a title copied from US screenshots will silently not match. "Show Sidebar"
# happens to be spelled the same in both.
#
# CAVEAT 2 — toggling items rename themselves. Safari's item is "Show Sidebar"
# when the sidebar is closed and "Hide Sidebar" when it is open, and each title
# needs its own entry or the shortcut only works in one direction. Hence the
# pairs in SHORTCUTS below.
#
# CAVEAT 3 — sandboxed apps keep defaults in their container, e.g.
# ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/. `defaults`
# follows that redirect on its own, so the plain bundle id is still correct here
# and hand-editing the container path is never needed.
#
# Discovering the exact title and checking a combo is free: dump the live menu
# bar through the Accessibility API. `status` below does this, or by hand —
#
#   osascript -e 'tell application "System Events" to tell process "Safari" \
#     to get name of every menu item of menu 1 of menu bar item "View" of menu bar 1'
#
# where AXMenuItemCmdChar is `missing value` for an unbound item, and
# AXMenuItemCmdModifiers is a bitmask: 0 = Command alone, +1 Shift, +2 Option,
# +4 Control, +8 drops Command.

set -euo pipefail

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || exit 1

# Shortcuts to install, as "<bundle id>|<exact menu item title>|<shortcut>".
#
# Safari 26 dropped the sidebar binding it had through Safari 14 — View > Show
# Sidebar has no key equivalent at all now, so this restores the old one rather
# than overriding anything. shift+cmd+l is free in Safari 26.6: cmd+l is Open
# Location, opt+cmd+l is Show Downloads, ctrl+cmd+l is Unlock All Private
# Windows.
# Single-quoted on purpose: `$` means Shift here, and in double quotes bash
# would expand it — silently, or as an unbound-variable abort under `set -u`.
SHORTCUTS=(
    'com.apple.Safari|Show Sidebar|@$l'
    'com.apple.Safari|Hide Sidebar|@$l'
)

# Bundle ids touched above, deduplicated — the set of apps to restart or clear.
apps() {
    local entry
    for entry in "${SHORTCUTS[@]}"; do
        echo "${entry%%|*}"
    done | sort -u
}

# Menu bar path of a running app, as "<title> :: <key> :: <modifier bitmask>"
# per bound item. Prints nothing if the app is not running, and fails loudly if
# the Accessibility API is refused — that permission is granted to the terminal,
# not to this script, so a fresh machine will prompt once.
menu_state() {
    local app=$1
    pgrep -qx "$app" || return 0
    osascript <<AS
tell application "System Events" to tell process "$app"
  set out to ""
  repeat with mb in (menu bar items of menu bar 1)
    repeat with mi in (menu items of menu 1 of mb)
      try
        set c to value of attribute "AXMenuItemCmdChar" of mi
        if c is not missing value then
          set out to out & (name of mi) & " :: " & (c as text) & " :: " & ¬
            (value of attribute "AXMenuItemCmdModifiers" of mi as text) & linefeed
        end if
      end try
    end repeat
  end repeat
  return out
end tell
AS
}

# Human-readable process name for a bundle id, which is what pgrep and System
# Events both key on ("com.apple.Safari" -> "Safari").
#
# Deliberately not `mdfind kMDItemCFBundleIdentifier` — Spotlight indexing is
# turned off on this machine (see install/README.md), so mdfind returns nothing
# and every lookup silently degrades to the bundle id.
#
# lsappinfo answers from LaunchServices, but only for a *running* app, so fall
# back to the last dot-component. That is right for well-formed bundle ids and
# wrong for ones that do not match their app name (com.googlecode.iterm2 is
# "iTerm2", not "iterm2") — add such an app to the case below.
#
# A case rather than an associative array on purpose: /bin/bash on macOS is
# still 3.2, which parses `declare -A` subscripts as arithmetic and dies on the
# dots in a bundle id.
process_name() {
    local name
    case "$1" in
    com.googlecode.iterm2)
        echo "iTerm2"
        return
        ;;
    esac
    name=$(lsappinfo info -only name "$1" 2>/dev/null | sed -n 's/.*"LSDisplayName"="\(.*\)"/\1/p')
    echo "${name:-${1##*.}}"
}

apply() {
    local entry bundle title combo
    for entry in "${SHORTCUTS[@]}"; do
        IFS='|' read -r bundle title combo <<<"$entry"
        echo "binding $bundle \"$title\" -> $combo"
        defaults write "$bundle" NSUserKeyEquivalents -dict-add "$title" "$combo"
    done

    local bundle
    for bundle in $(apps); do
        restart_app "$(process_name "$bundle")"
    done
}

clear_all() {
    local bundle
    for bundle in $(apps); do
        echo "clearing NSUserKeyEquivalents for $bundle"
        defaults delete "$bundle" NSUserKeyEquivalents 2>/dev/null || true
        restart_app "$(process_name "$bundle")"
    done
}

status() {
    local bundle name
    for bundle in $(apps); do
        name=$(process_name "$bundle")
        echo "=== $bundle ($name) ==="
        defaults read "$bundle" NSUserKeyEquivalents 2>/dev/null ||
            echo "  (no custom shortcuts recorded)"
        if pgrep -qx "$name"; then
            echo "  live menu bar:"
            menu_state "$name" | sed 's/^/    /'
        else
            echo "  $name not running, cannot read live menu"
        fi
    done
}

# AppKit only consults NSUserKeyEquivalents while it builds the menu bar, so a
# running app keeps its old shortcuts until it is relaunched.
#
# Deliberately advisory: never quit anything, just say what is left to do. A
# browser is the wrong thing to close out from under someone — it can be holding
# unsaved form input or a download in flight — and staying non-interactive keeps
# this safe to call unattended from install.sh. The cost is that `apply` only
# does half the job, so the reminder has to be hard to miss.
#
# `killall` would be wrong here regardless: SIGTERM skips Safari's session save,
# so tabs come back wrong.
#
# $1 is the process name, e.g. "Safari"; it may not be running.
restart_app() {
    local name=$1
    if pgrep -qx "$name"; then
        echo "  ACTION REQUIRED: quit and reopen $name — it will not pick this up while running"
    else
        echo "  $name is not running, it will pick this up at next launch"
    fi
}

case "${1:-}" in
apply) apply ;;
status) status ;;
clear) clear_all ;;
*)
    echo "usage: $0 {apply|status|clear}"
    echo
    echo "  apply   write the shortcuts in SHORTCUTS to user defaults"
    echo "  status  show recorded shortcuts, and the live menu bar if running"
    echo "  clear   drop every NSUserKeyEquivalents entry for the apps involved"
    exit 1
    ;;
esac
