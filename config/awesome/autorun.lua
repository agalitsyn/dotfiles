-- dual screens
run_once("xrandr", "--output VGA-0 --mode 1920x1080 --right-of DVI-0")

-- keyboard
run_once("setxkbmap", "-option grp:switch,grp:alt_shift_toggle,grp_led:caps,caps:none us,ru")

-- starts screensaver daemon
run_once("xscreensaver", "-no-splash")

-- turn numlock on
run_once("numlockx")
-- pcmanfm have bug with numlock, see http://sourceforge.net/p/pcmanfm/bugs/482/

-- hide mouse cursor when it not used
-- run_once("unclutter")

-- dropbox daemon
run_once(os.getenv("HOME") .. "/.dropbox-dist/dropboxd")

-- java fix
run_once("wmname", "LG3D")
