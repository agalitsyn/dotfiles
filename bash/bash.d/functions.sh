# Create a new directory and enter it
md() {
    mkdir -pv "$@" && cd "$@"
}

# find shorthand
f() {
    find . -name "$1"
}

# Goto temp dir
cdt() {
    [ -z "$TMPDIR" ] && cd /tmp || cd "$TMPDIR"
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}

# Determine size of a file or total size of a directory
filesize() {
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
dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
extract() {
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

# `vs` with no arguments opens the current directory in vs code, otherwise
# opens the given location
vs() {
    if [ $# -eq 0 ]; then
        code .
    else
        code "$@"
    fi
}

# `o` with no arguments opens current directory, otherwise opens the given
# location
o() {
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
tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Get the introductory paragraph from a Wikipedia article using the inimitable
# David Leadbeater's Wikipedia-over-DNS service.
#
# See https://dgl.cx/wikipedia-dns
wp() {
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
udiff() {
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
duh() {
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
vack() {
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
lc() {
    if [ $# -eq 0 ]; then
        tr '[:upper:]' '[:lower:]'
    else
        tr '[:upper:]' '[:lower:]' < "$@"
    fi
}

# Convert the parameters or STDIN to uppercase.
uc() {
    if [ $# -eq 0 ]; then
        tr '[:lower:]' '[:upper:]'
    else
        tr '[:lower:]' '[:upper:]' < "$@"
    fi
}

wait-for-http() {
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

# Simple calculator
calc() {
	local result=""
	result="$(printf "scale=10;%s\\n" "$*" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		# add "0" for cases like ".5"
		# add "0" for cases like "-.5"
		# remove trailing zeros
		printf "%s" "$result" |
			sed -e 's/^\./0./'  \
			-e 's/^-\./-0./' \
			-e 's/0*$//;s/\.$//'
	else
		printf "%s" "$result"
	fi
	printf "\\n"
}

# Generate random password
pswdgen() {
    local length="${1:-21}"

    echo "Strong password and hash:"
	PASSWORD=$(base64 < /dev/urandom | head -c "$length")
	echo "$PASSWORD"
	echo -n "$PASSWORD" | sha256sum | tr -d '-'

	echo
    echo "Strong:"
    LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()\-+=' < /dev/urandom | head -c "$length" | xargs

	echo
    echo "Middle:"
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$length" | xargs

	echo
    echo "Simple:"
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c "$length" | xargs

	echo
    echo "Simple 2:"
    LC_ALL=C tr -dc 'a-zA-Z' < /dev/urandom | head -c "$length" | xargs
}

# Clip web site to markdown
webclipper() {
    local usage="Usage: clip-note <url> <file-path>"
    local url="${1:?$usage}"
    local file="${2:?$usage}"

    pandoc -s -r html $url -o $file.md
}

settitle() {
  PROMPT_COMMAND="echo -ne \"\033]0;$@\007\""
}
