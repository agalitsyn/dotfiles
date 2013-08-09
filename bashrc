export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -lh'
alias l='ls $LS_OPTIONS -lA'

export LESS="--RAW-CONTROL-CHARS"

[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP
export GREP_OPTIONS="--color=auto"

alias vi='vim'
alias less='less -Ri'
alias bashrc='vi ~/.bashrc && source ~/.bashrc'
alias rsync='rsync --exclude .svn'

[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f .bash_extra ] && . .bash_extra

export HISTSIZE=10000
export PATH=$PATH:~/bin:/sbin:/usr/sbin
export EDITOR=vim

# Show current SVN revision or Git branch

scm_ps1() {
local s=
if [[ -d ".svn" ]] ; then
s=\(svn:$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )\)
else
if [[ $(declare -f __git_ps1) ]]; then # Only show if completion is there
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
s=$(__git_ps1 "(git:%s)")
fi
fi
echo -n "$s"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]\$(scm_ps1)\[\033[00m\]\$ "

alias pswd-gen='php ~/.pswd-gen'
alias vhost='php ~/.vhost'