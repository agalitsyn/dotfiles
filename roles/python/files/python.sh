pythonrc_path="$HOME/.pythonrc"
[ -e $pythonrc_path ] && export PYTHONSTARTUP=$pythonrc_path

export PYTHONIOENCODING="UTF-8"

function python-upgrade-in-virtualenv() {
    local usage="Usage: python-upgrade-in-virtualenv {venv-dir}"
    local target="${1:?$usage}"

    find "./$target/" -type l -delete
    virtualenv "$target"
}

# Start an HTTP server from a directory, optionally specifying the port
function python-server() {
    local port="${1:-8000}"
    open "http://localhost:${port}/"
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

