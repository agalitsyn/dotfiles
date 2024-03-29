#!/usr/bin/env/bash

set -xe

pipx install djlint

echo
echo "installation paths"
pipx environment --value PIPX_LOCAL_VENVS

