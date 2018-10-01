#!/usr/bin/env/bash

set -xe

CONFIG=$HOME/.config/sublime-text-3
[[ "$OSTYPE" == "linux-gnu" ]] || CONFIG=$HOME/Library/Application Support/Sublime\ Text\ 3/

mkdir -p "$CONFIG/Packages/User"
cp config/* "$CONFIG/Packages/User"
