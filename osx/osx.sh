export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="/usr/local/opt/curl/bin:$PATH"

export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# OSX has builtin apache2
alias apache2-start="sudo apachectl -k start"
alias apache2-stop="sudo apachectl -k stop"
alias apache2-restart="sudo apachectl -k restart"

# postgres from homebrew
alias postgresql-start="pg_ctl -D /usr/local/var/postgres start"
alias postgresql-stop="pg_ctl -D /usr/local/var/postgres stop"

