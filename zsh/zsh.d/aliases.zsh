# gnu utils modern alternatives
alias l='exa --all --long --group-directories-first'
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

function timestamp-to-datetime() {
    local ts="$1"
    python3 -c "from datetime import datetime; ts = int('${ts}'); print(datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S.%f'));"
}

# web dev
function jwt-decode() {
    local token="$1"
    python3 -c "import json, jwt; print(json.dumps(jwt.decode('${token}', verify=False)));" | jq
}

# Files

# file find
alias f='fd'

# file fuzzy search and open
if command -v open > /dev/null; then
  alias fo='open $(fzf)';
elif command -v xdg-open > /dev/null; then
  alias fo='xdg-open $(fzf)';
fi;

# file search by content
function fs() {
  rg -p "$@" | less -XFR
}

# file tree
# shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function ft() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# File size
alias fs="stat $1"

# File path
alias fp="readlink -f $1"

