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

osascript -e 'tell application "Ghostty"
    activate
    tell application "System Events"
        keystroke "n" using command down
    end tell
end tell'

