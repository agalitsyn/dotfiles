#!/bin/sh
xrandr --output eDP-1 --mode 1920x1080 --pos 0x360 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output DP-3 --off --output DP-4 --off --output DP-5 --off --output HDMI-1-0 --off
sleep 1
nitrogen --restore
