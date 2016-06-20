# mostly via DO site
# @see https://www.digitalocean.com/community/articles/an-introduction-to-useful-bash-aliases-and-functions

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

color_flag="--color"

# file listing
alias ls='ls $color_flag --group-directories-first -p -CF';
alias ll='ls -lh $color_flag --group-directories-first';
alias lsa='ls -ahCF --group-directories-first';
alias lla='ls -alh --group-directories-first';
alias l='ls'

# list file permissions in octal
# @see http://www.shell-fu.org/lister.php?id=205
alias lso="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'"

# list file by inode number
alias lsi='ls -il'

# delete a file by its inode number
# @see http://www.shell-fu.org/lister.php?id=232
function rminode() {
    find . -inum $1 -delete
}

# list and find files/folders
# @see http://chneukirchen.org/blog/archive/2013/07/summer-of-scripts-l-and-lr.html
function lf() {
  local p=$argv[-1]
  [[ -d $p ]] && { argv[-1]=(); } || p='.'
  find $p ! -type d | sed 's:^./::' | egrep "${@:-.}"
}

# search and replace
# @see http://www.reddit.com/r/programming/comments/2tj6d6/findrep_easy_tool_to_find_and_replace/cnzy34o
function findreplace { 
    if [ ! $# == 2 ]; then 
        echo "Usage: find_replace <search_string> <replace_string>"
        return -1
    fi
    find . -type f -print0 | xargs -0 sed -i "s/$1/$2/g"
}

# Alias l='ls -lA $color_flag'
alias lsd='ls -l | grep "^d"'

alias dir='dir $color_flag'
alias vdir='vdir $color_flag'

grep_options="--exclude=*.pyc --exclude-dir=.git --exclude-dir=.svn"
alias grep='grep $color_flag $grep_options'
alias fgrep='fgrep $color_flag $grep_options'
alias egrep='egrep $color_flag $grep_options'

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

# Confirm before overwriting
# -----------------------------------------------------------------------------
# I know it is bad practice to override the default commands, but this is for
# safety. If you really want the original "instakill" versions, you can
# use "command rm", "\rm", or "/bin/rm" inside your own commands, aliases, or
# shell functions. Note that separate scripts are not affected by the aliases
# defined here.
alias cp='cp -i';
alias mv='mv -i';
alias rm='rm -i';

# Programs
alias vim="stty stop '' -ixoff ; vim" # keep all my configs when run as root
alias vi='vim'
alias v='vim -R'
alias view='vim -R'
alias less='less -Ri'

alias rsync='rsync --cvs-exclude --verbose --archive --compress --copy-links --partial --progress --delete'

alias g='git'
[ -f "/usr/share/bash-completion/completions/git" ] && source /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g

# Always use chrome as mp3 and video player, pdf viewer, etc
alias gc="google-chrome --new-window"

# Date & time shortcuts
alias mcal="date +%Y-%m-%d; cal -A 1 -B 1"

# Force tmux 256 color
alias tmux="tmux -2"

# `cat` with beautiful colors. requires Pygments installed.
#  sudo easy_install Pygments
alias c='pygmentize -O style=monokai -f console256 -g'

# Enable simple aliases to be sudo'ed.
# http://www.gnu.org/software/bash/manual/bashref.html#Aliases says: "If the
# last character of the alias value is a space or tab character, then the next
# command word following the alias is also checked for alias expansion."
alias sudo='sudo ';

# Handy stuff
alias please=sudo
alias hosts='sudo $EDITOR /etc/hosts'
alias bashrc='$EDITOR ~/.bashrc && source ~/.bashrc'

# Stupid hardcode way to check network interface
if /sbin/ifconfig eth0 > /dev/null 2>&1; then
    # Ubuntu
    ninterface='eth0'
else
    # OS X
    ninterface='en1'
fi

# IP addresses
alias externalip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr ${ninterface}"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias sniff="sudo ngrep -d '${ninterface}' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i ${ninterface} -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
type -t hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum="md5"

# Trim new lines and copy to clipboard
alias trimcopy="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# File size
alias fs="stat -f \"%z bytes\""

# File path
alias fp="readlink -f $1"

# ROT13-encode/decode text.
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash; sudo rm -rfv ~/.local/share/Trash/files/*"

# Clipboard access. I created these aliases to have the same command on
# Cygwin, Linux and OS X.
if command -v pbpaste > /dev/null; then
    alias getclip='pbpaste';
    alias setclip='pbcopy';
elif command -v xclip > /dev/null; then
    alias getclip='xclip --out';
    alias setclip='xclip --in';
fi;

# Screenshots
alias screenshot-upload='import png:- | curl -T- -s chunk.io'
alias screenshot-window="scrot --count --delay 3 --focused ~/Pictures/screenshots/%Y-%m-%d-%T-screenshot.png"
alias screenshot-selection="scrot --select ~/Pictures/screenshots/%Y-%m-%d-%T-screenshot.png"
