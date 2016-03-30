# Enable completions from homebrew for OS X
if [ `type -t brew` > /dev/null ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
