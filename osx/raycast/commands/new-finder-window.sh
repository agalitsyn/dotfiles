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

osascript -e 'tell application "Finder" to make new Finder window'

