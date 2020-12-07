function touchpad-toggle() {
    if synclient -l | egrep "TouchpadOff.*= *0"; then
        synclient touchpadoff=1;
    else
        synclient touchpadoff=0;
    fi
}

function desktop-mode() {
    xrandr \
        --output eDP1 --mode 1920x1080  --primary \
        --output HDMI1 --mode 1920x1200 --above eDP1 \
        --output VGA1 --off \
        --output DP1 --off

    feh --bg-scale ~/.config/i3/bg.jpg

    i3-msg restart

    synclient touchpadoff=1;
}

function laptop-mode() {
    xrandr \
        --output eDP1 --mode 1920x1080 --primary \
        --output HDMI1 --off \
        --output VGA1 --off \
        --output DP1 --off

    feh --bg-scale ~/.config/i3/bg.jpg

    i3-msg restart

    synclient touchpadoff=0;
}

