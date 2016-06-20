#!/usr/bin/env bash

laptop-mode

# See man xkeyboard-config
setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:caps,caps:escape us,ru
numlockx &
unclutter &
fbxkb &

redshift -m drm -l 43:75 &

dunst -config ~/.config/dunst/dunstrc &

xautolock -time 5 -locker 'i3lock --nofork --dpms --color 000000' &
pulseaudio --start &

parcellite &
pasystray &

dropbox start &
