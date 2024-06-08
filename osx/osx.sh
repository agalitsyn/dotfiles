eval $(/opt/homebrew/bin/brew shellenv)

export HOMEBREW_NO_AUTO_UPDATE=true

# link all bins
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# link python3 as python
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"

# substitute man pages
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="/opt/homebrew/opt/curl/bin:$PATH"

export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl/lib/pkgconfig"
export LDFLAGS="-I/opt/homebrew/opt/openssl/include -L/opt/homebrew/opt/openssl/lib"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export PATH=~/.local/bin:$PATH

# Fix mc slow startup
alias mc="mc --nosubshell"

# OSX has builtin apache2
alias apache2-start="sudo apachectl -k start"
alias apache2-stop="sudo apachectl -k stop"
alias apache2-restart="sudo apachectl -k restart"

# postgres from homebrew
alias postgresql-start="pg_ctl -D /opt/homebrew/var/postgres start"
alias postgresql-stop="pg_ctl -D /opt/homebrew/var/postgres stop"

# memcached from homebrew
alias memcached-start="memcached -vv"
alias memcached-statistics="memstat --servers=127.0.0.1:11211"
alias memcached-dump="memdump --servers=127.0.0.1:11211"

# cd into whatever is the forefront Finder window.
function cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}

function anybar {
    echo -n $1 | nc -u -c localhost ${2:-1738}
}

function ss {
    sudo lsof -nP -iTCP -sTCP:LISTEN
}

function get_os_theme {
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)"  == "Dark" ]]; then
        export OS_THEME='dark'
        export DELTA_FEATURES="+dark-mode"
    else
        export OS_THEME='light'
        export DELTA_FEATURES="+light-mode"
    fi
}
get_os_theme

# If iTerm is detected these themes are used for regular windows
# and ssh respectively
ITERM_NORMAL_PROFILE='Fancy'
ITERM_SSH_PROFILE='FancySSH'

# On iTerm we switch terminals for SSH if we have it.  This switches to
# the SSH profile and back when ssh is run from the terminal.
if [[ "$TERM_PROGRAM" == iTerm.app ]]; then
  function ssh() {
    echo -n -e $'\033]50;SetProfile='$ITERM_SSH_PROFILE'\a'
    command ssh "$@"
    echo -n -e $'\033]50;SetProfile='$ITERM_NORMAL_PROFILE'\a'
  }
fi

