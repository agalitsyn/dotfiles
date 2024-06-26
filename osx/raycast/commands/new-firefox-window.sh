#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Firefox Window
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🌐
# @raycast.packageName

# Documentation:
# @raycast.description
# @raycast.author
# @raycast.authorURL

# osascript -e 'id of app "Firefox"'
browser='org.mozilla.firefox'
open --new -b "$browser"
