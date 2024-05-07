#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Default Browser Window
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🌐
# @raycast.packageName

# Documentation:
# @raycast.description
# @raycast.author
# @raycast.authorURL

# https://stackoverflow.com/a/66026925/13949806
defaultBrowser=$(plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}')
open --new -b "$defaultBrowser"
