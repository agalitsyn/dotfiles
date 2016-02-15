#!/usr/bin/env bash

xrandr --output eDP1 --mode 1600x900 --rotate normal --primary
xrandr --output HDMI1 --mode 1920x1200 --above eDP1
feh --bg-scale ~/.config/i3/bg.jpg

# See man xkeyboard-config
setxkbmap -option grp:switch,grp:alt_space_toggle,grp_led:caps,caps:escape us,ru
#xmodmap -e 'keycode 66 = Escape NoSymbol Escape' &
numlockx &
unclutter &
fbxkb &

dunst -config ~/.config/dunst/dunstrc &

xautolock -time 5 -locker 'i3lock --nofork --dpms --color 000000' &
pulseaudio --start &
#smbnetfs ~/samba &
#urxvtd -q -o -f &

parcellite &
pasystray &

dropbox start &
