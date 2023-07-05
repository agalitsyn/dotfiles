#!/usr/bin/env/bash

set -xe

CONFIG=$HOME/.config/sublime-text
[[ "$OSTYPE" == "linux-gnu" ]] || CONFIG=$HOME/Library/Application\ Support/Sublime\ Text

mkdir -p "$CONFIG/Packages/User"
# copy instead of linking because sublime reformats it and delete all the comments
cp config/* "$CONFIG/Packages/User"
