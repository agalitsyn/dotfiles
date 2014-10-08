#!/bin/sh
# vim: ts=4 sts=4 sw=4 noet:

set -e

echo "Attention, it will destory all symlinks in" $HOME
echo "Are you sure? (y/n)"

read proceed
if [ "$proceed" = 'N' ] || [ "$proceed" = 'n' ]; then
    echo "Canceled."
else
    find $HOME -maxdepth 1 -type l -exec rm -vf {} \;
fi
