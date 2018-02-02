#!/usr/bin/env bash

# See man xkeyboard-config
fbxkb &

redshift -m drm -l 43:75 &


xautolock -time 5 -locker 'i3lock --nofork --dpms --color 000000' &

parcellite &
pasystray &

