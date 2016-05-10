#!/usr/bin/env bash

xrandr \
    --output eDP1 --mode 1600x900 --rotate normal --primary \
    --output HDMI1 --off \
    --output VGA1 --off \
    --output DP1 --off

feh --bg-scale ~/.config/i3/bg.jpg

# See man xkeyboard-config
setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:caps,caps:escape us,ru
#xmodmap -e 'keycode 66 = Escape NoSymbol Escape' &
numlockx &
unclutter &
fbxkb &

redshift -l 54.980645:82.895525 -t 6500:5000 -b 1.0:0.8 &

dunst -config ~/.config/dunst/dunstrc &

xautolock -time 5 -locker 'i3lock --nofork --dpms --color 000000' &
pulseaudio --start &
#smbnetfs ~/samba &
#urxvtd -q -o -f &

parcellite &
pasystray &

dropbox start &
