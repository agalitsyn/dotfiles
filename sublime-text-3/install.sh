#!/usr/bin/env/bash

set -xe

CONFIG=$HOME/.config/sublime-text-3
[[ "$OSTYPE" == "linux-gnu" ]] || CONFIG=$HOME/Library/Application\ Support/Sublime\ Text\ 3/

mkdir -p "$CONFIG/Packages/User"
# copy instead of linking because sublime reformats it and delete all the comments
cp config/* "$CONFIG/Packages/User"
