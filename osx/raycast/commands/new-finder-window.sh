#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Finder Window
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📁
# @raycast.packageName

# Documentation:
# @raycast.description Open new Finder window
# @raycast.author
# @raycast.authorURL

osascript -e 'tell application "Finder"
    set newWindow to make new Finder window
    set target of newWindow to folder "Downloads" of home
    activate newWindow
end tell'

exit 0

