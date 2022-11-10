#!/bin/sh
xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off --output HDMI-1-0 --off
sleep 1
setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:caps,caps:escape us,ru
nitrogen --restore

