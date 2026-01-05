#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Terminal Window
# @raycast.mode compact

# Optional parameters:
# @raycast.icon
# @raycast.packageName

# Documentation:
# @raycast.description
# @raycast.author
# @raycast.authorURL

#WEZTERM_UNIX_SOCKET=~/.local/share/wezterm/default-org.wezfurlong.wezterm wezterm cli spawn --new-window

osascript -e 'tell application "System Events"
    if (name of processes) contains "Ghostty" then
        tell process "Ghostty"
            click menu item "New Window" of menu "File" of menu bar 1
        end tell
        tell application "Ghostty" to activate
    else
        tell application "Ghostty" to activate
    end if
end tell'

exit 0

