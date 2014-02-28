run_once("xrandr", "--output VGA-0 --mode 1920x1080 --right-of DVI-0") -- dual screens
run_once("setxkbmap", "-option grp:switch,grp:alt_shift_toggle,grp_led:scroll,caps:none us,ru") -- keyboard
run_once("xscreensaver", "-no-splash") -- starts screensaver daemon
run_once("numlockx") -- turn numlock on
run_once("unclutter") -- hide mouse cursor when it not used
run_once(os.getenv("HOME") .. "/.dropbox-dist/dropboxd") -- dropbox daemon
run_once("wmname", "LG3D") -- java fix
