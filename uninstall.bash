#!/usr/bin/env bash

echo 'Attention, it will destory all symlinks in' $HOME
echo 'Are you sure? (y/n)'

read proceed
if [[ $proceed == "N" || $proceed == "n" ]]; then
    echo "Canceled."
else
    find $HOME -maxdepth 1 -type l -exec rm -vf {} \;
fi
