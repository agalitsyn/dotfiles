########################
### Files and folder ###
########################

# Create a new directory and enter it
function md() {
    mkdir -pv "$@" && cd "$@"
}

# find shorthand
function f() {
    find . -name "$1"
}

# Goto temp dir
function cdt() {
    [ -z "$TMPDIR" ] && cd /tmp || cd "$TMPDIR"
}

# Determine size of a file or total size of a directory
function filesize() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f "$1" ]; then
        local filename=$(basename "$1")
        local foldername="${filename%%.*}"
        local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
        local didfolderexist=false
        if [ -d "$foldername" ]; then
            didfolderexist=true
            read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                return
            fi
        fi
        mkdir -p "$foldername" && cd "$foldername"
        case $1 in
            (*.tar.bz2) tar xjf "$fullpath" ;;
            (*.tar.gz) tar xzf "$fullpath" ;;
            (*.tar.xz) tar Jxvf "$fullpath" ;;
            (*.tar.Z) tar xzf "$fullpath" ;;
            (*.tar) tar xf "$fullpath" ;;
            (*.taz) tar xzf "$fullpath" ;;
            (*.tb2) tar xjf "$fullpath" ;;
            (*.tbz) tar xjf "$fullpath" ;;
            (*.tbz2) tar xjf "$fullpath" ;;
            (*.tgz) tar xzf "$fullpath" ;;
            (*.txz) tar Jxvf "$fullpath" ;;
            (*.zip|*.war|*.jar) unzip "$fullpath" ;;
            (*.rar) unrar x -ad "$fullpath" ;;
            (*.7z) 7za x "$fullpath" ;;
            (*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
function s() {
    if [ $# -eq 0 ]; then
        subl .
    else
        subl "$@"
    fi
}

# `o` with no arguments opens current directory, otherwise opens the given
# location
function o() {
    local fm=
    if command -v nautilus > /dev/null; then
        fm='nautilus'
    elif command -v open > /dev/null; then
        fm='open'
    fi

    if [ $# -eq 0 ]; then
        $fm .
    else
        $fm "$@"
    fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Get the introductory paragraph from a Wikipedia article using the inimitable
# David Leadbeater's Wikipedia-over-DNS service.
#
# See https://dgl.cx/wikipedia-dns
function wp() {
    query="$*"
    domain="${query// /_}.wp.dg.cx"
    answer="$(dig +short -t txt "$domain" | perl -p -e 's/\\([0-9]*)/chr($1)/eg')"
    answer="${answer:1}"

    while [ -n "$answer" ]; do
        chunk_length=255
        [ "${#answer}" -lt 256 ] && chunk_length=$((${#answer} - 1))
        text="${text}${answer:0:$chunk_length}"
        answer="${answer:$(($chunk_length + 3))}"
    done

    echo "$text"
}

# Show a unified diff, colourised if possible and paged if necessary.
function udiff() {
    if command -v colordiff > /dev/null; then
        colordiff -wU4 "$@" | $PAGER
        return ${PIPESTATUS[0]}
    elif command -v git > /dev/null && ! [[ " $* " =~ \ /dev/fd ]]; then
        git diff --no-index "$@"
        return $?
    fi

    diff -wU4 -x .svn "$@" | $PAGER
    return ${PIPESTATUS[0]}
}

# Sort the "du" output and use human-readable units.
function duh() {
    du -sk "$@" | sort -n | while read size fname; do
        for unit in KiB MiB GiB TiB PiB EiB ZiB YiB; do
            if [ "$size" -lt 1024 ]; then
                echo -e "${size} ${unit}\t${fname}"
                break
            fi
            size=$((size/1024))
        done
    done
}

# Edit the files found with the previous "ack" command using Vim (or the
# default editor).
function vack() {
    local cmd=''
    if [ $# -eq 0 ]; then
        cmd="$(fc -nl -1)"
        cmd="${cmd:2}"
    else
        cmd='ack'
        for x; do
            cmd="$cmd $(printf '%q' "$x")"
        done
        echo "$cmd"
    fi
    if [ "${cmd:0:4}" != 'ack ' ]; then
        $cmd
        return $?
    fi
    declare -a files
    while read -r file; do
        echo "$file"
        files+=("$file")
    done < <(bash -c "${cmd/ack/ack -l}")
    vim -p "${files[@]}"
}

# Convert the parameters or STDIN to lowercase.
function lc() {
    if [ $# -eq 0 ]; then
        tr '[:upper:]' '[:lower:]'
    else
        tr '[:upper:]' '[:lower:]' < "$@"
    fi
}

# Convert the parameters or STDIN to uppercase.
function uc() {
    if [ $# -eq 0 ]; then
        tr '[:lower:]' '[:upper:]'
    else
        tr '[:lower:]' '[:upper:]' < "$@"
    fi
}

function wait-for-http() {
    local usage="wait_for_endpoint <endpoint> [poll_interval] [retries]"
    local endpoint=${1:?$usage}
    local poll_interval=${2:-1}
    local attempts=${3:-10}

    attempt=1
    until $(curl --output /dev/null --silent --head --fail $endpoint); do
        echo "Endpoint \"$endpoint\" is not available. Attempt $attempt of $attempts."

        if [[ $attempt -eq $attempts ]]; then
            die "all attempts were failed"
        fi

        sleep $poll_interval
        ((attempt++))
    done
}

##############
### Docker ###
##############

function docker-enter() {
    docker exec -it $1 bash
}

function docker-images-cleanup() {
    docker rmi $(docker images | awk '/^<none>/ {print $3}')
}

function docker-containers-cleanup() {
    docker rm $(docker ps --all -q -f status=exited)
}

#############
### Tools ###
#############

# Simple calculator
function calc() {
    local result=""
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
    #                       └─ default (when `--mathlib` is used) is 20

    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
        sed -e 's/^\./0./' \
            -e 's/^-\./-0./' \
            -e 's/0*$//;s/\.$//'
    else
        printf "$result"
    fi

    printf "\n"
}

# Generate random password
function pswdgen() {
    local length="${1:-12}"

    echo "Strong:"
    LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()\-+=' < /dev/urandom | head -c "$length" | xargs
    echo "Middle:"
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$length" | xargs
    echo "Simple:"
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c "$length" | xargs
    echo "Simple 2:"
    LC_ALL=C tr -dc 'a-zA-Z' < /dev/urandom | head -c "$length" | xargs
}

# Notes app
function note() {
    terminal_velocity "$@"
}

# Clip web site to markdown
function webclipper() {
    local usage="Usage: clip-note <url> <file-path>"
    local url="${1:?$usage}"
    local file="${2:?$usage}"

    pandoc -s -r html $url -o $file.md
}
