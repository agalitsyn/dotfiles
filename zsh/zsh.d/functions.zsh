# Grep alternative
function rgp() {
  rg -p "$@" | less -XFR
}

# Create a new directory and enter it
function md() {
    mkdir -pv "$@" && cd "$@"
}

# Goto temp dir
function cdt() {
    [ -z "$TMPDIR" ] && cd /tmp || cd "$TMPDIR"
}

# cd into whatever is the forefront Finder window.
function cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

function jwt-decode() {
    local token="$1"
    python3 -c "import json, jwt; print(json.dumps(jwt.decode('$token', verify=False)));" | jq
}

