# nvim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# gnu utils modern alternatives
alias l='eza --all --long --group-directories-first'
alias c='bat'

color_flag="--color"

# ls options: A = include hidden (but not . or ..), F = put `/` after folders, h = byte unit suffixes
alias ls='ls $color_flag --group-directories-first -p -CAFh';
alias ll='ls -lah $color_flag --group-directories-first'
alias lsd='ls -l | grep "^d"' # only directories

# list file permissions in octal
# @see http://www.shell-fu.org/lister.php?id=205
alias lso="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'"

# list file by inode number
alias lsi='ls -il'

# Alias l='ls -lA $color_flag'
alias lsd='ls -l | grep "^d"'

alias dir='dir $color_flag'
alias vdir='vdir $color_flag'

grep_options="--exclude=*.pyc --exclude-dir=.git --exclude-dir=.svn"
alias grep='grep $color_flag $grep_options'
alias fgrep='fgrep $color_flag $grep_options'

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# Handy make directory
alias mkdir='mkdir -pv'

# Create a new directory and enter it
function md() {
    mkdir -pv "$@" && cd "$@"
}

# Goto temp dir
function cdt() {
    [ -z "$TMPDIR" ] && cd /tmp || cd "$TMPDIR"
}

# Confirm before overwriting
# -----------------------------------------------------------------------------
# I know it is bad practice to override the default commands, but this is for
# safety. If you really want the original "instakill" versions, you can
# use "command rm", "\rm", or "/bin/rm" inside your own commands, aliases, or
# shell s. Note that separate scripts are not affected by the aliases
# defined here.
alias cp='cp -i';
alias mv='mv -i';
alias rm='rm -i';

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash; sudo rm -rfv ~/.local/share/Trash/files/*"

# Pager
alias less='less -Ri'

# Enable simple aliases to be sudo'ed.
# http://www.gnu.org/software/bash/manual/bashref.html#Aliases says: "If the
# last character of the alias value is a space or tab character, then the next
# command word following the alias is also checked for alias expansion."
alias sudo='sudo ';

# Handy stuff
alias hosts='sudo $EDITOR /etc/hosts'

# Stupid hardcode way to check network interface
# TODO: seems not working for ubuntu 16.04+
if /sbin/ifconfig eth0 > /dev/null 2>&1; then
    # Ubuntu
    ninterface='eth0'
else
    # OS X
    ninterface='en1'
fi

# IP addresses
alias external-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local-ip="ifconfig getifaddr ${ninterface}"
#alias local-ips="sudo nmap -sP 192.168.0.0/24"
alias local-ips="sudo arp-scan --localnet"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias sniff="sudo ngrep -d '${ninterface}' -t '^(GET|POST) ' 'tcp and port 80'"
alias http-dump="sudo tcpdump -i ${ninterface} -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
type hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
type md5sum > /dev/null || alias md5sum="md5"

# ROT13-encode/decode text.
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Trim new lines and copy to clipboard
alias trimcopy="tr -d '\n' | pbcopy"

# Clipboard access. I created these aliases to have the same command on
# Cygwin, Linux and OS X.
if command -v pbpaste > /dev/null; then
    alias getclip='pbpaste';
    alias setclip='pbcopy';
elif command -v xclip > /dev/null; then
    alias getclip='xclip --out';
    alias setclip='xclip --in';
fi;

# Use GNU time
alias gtime='/usr/bin/time'

# Enhanced rsync
alias mrsync='rsync --cvs-exclude --verbose --archive --compress --copy-links --partial --progress --delete'

# Date & time shortcuts
alias mcal="date +%Y-%m-%d; cal -A 1 -B 1"
alias timestamp='date +%s'

# web dev
function jwt-decode() {
    local token="$1"
    python3 -c "import json, jwt; print(json.dumps(jwt.decode('${token}', verify=False)));" | jq
}

function timestamp-to-datetime() {
    local ts="$1"
    python3 -c "from datetime import datetime; ts = int('${ts}'); print(datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S.%f'));"
}

### Files

# file find
alias f="find . -name $1"

# file open: fuzzy search and open
if command -v open > /dev/null; then
  alias fo='open $(fzf)';
elif command -v xdg-open > /dev/null; then
  alias fo='xdg-open $(fzf)';
fi;

# rg settings
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/config

# file tree
# shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components|vendor|.venv' --dirsfirst "$@" | less -FRNX
}

# file size
alias fstat="stat $1"

# file path
alias fpath="readlink -f $1"

# diff 2 files
function gdiff() {
    git diff --no-index $1 $2
}

# archive
function extract() {
    if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    elif [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.tar.xz)    tar xvJf "$1"    ;;
            *.lzma)      unlzma "$1"      ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.xz)        unxz "$1"        ;;
            *.exe)       cabextract "$1"  ;;
            *)           echo "extract: '$1' - unknown archive method" ;;
        esac
        echo "extraction successful: $1"
    else
        echo "$1 - file does not exist"
    fi
}

function youtube-dl-playlist() {
    yt-dlp -f "bestvideo+bestaudio" --yes-playlist -o "%(playlist_index)s-%(title)s-%(id)s.%(ext)s" --embed-chapters --cookies-from-browser brave $@
}

function youtube-dl-video() {
    yt-dlp -f "bestvideo+bestaudio" --no-playlist -o "%(title)s-%(id)s.%(ext)s" --embed-chapters --cookies-from-browser brave $@
}

function what-is-my-ip() {
    curl -s wtfismyip.com/json | jq -r "\"🌐 Public IP: \" + .YourFuckingIPAddress + \"\n📍 Location: \" + .YourFuckingLocation + \"\n🏢 ISP: \" + .YourFuckingISP + \"\n🌍 Country: \" + .YourFuckingCountryCode"
}

