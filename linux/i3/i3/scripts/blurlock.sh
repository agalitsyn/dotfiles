#!/bin/bash
set -eu

RESOLUTION=$(xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')

# use latest i3lock with `show kayboard layout` feature
import -silent -window root jpeg:- | convert - -scale 20% -blur 0x3 -resize 500% RGB:- | \
    i3lock --show-failed-attempts --show-keyboard-layout --raw $RESOLUTION:rgb -i /dev/stdin -e $@

# sleep 1 adds a small delay to prevent possible race conditions with suspend
sleep 1

exit 0
