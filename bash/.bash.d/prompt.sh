# Show current SVN revision or Git branch
scm_ps1()
{
    local s=

    if [[ -d ".svn" ]] ; then
        s=\(svn: $(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )\)
    else
        if [[ $(declare -f __git_ps1) ]]; then
            # Native way
            GIT_PS1_SHOWDIRTYSTATE=true
            GIT_PS1_SHOWSTASHSTATE=true
            GIT_PS1_SHOWUNTRACKEDFILES=true
            s=$(__git_ps1 "(git: %s)")
        else
            # Spike way
            # check if we're in a git repo
            git rev-parse --is-inside-work-tree &>/dev/null || return

            # quickest check for what branch we're on
            branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')

            # check if it's dirty (via github.com/sindresorhus/pure)
            dirty=$(git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ]&& echo -e "*")

            echo $WHITE" on "$PURPLE$branch$dirty
        fi
    fi

    echo -n "$s"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # Mac OSX 10.9 added some additional security checks for strcpy
    # The prompt expansion for \w calls strcpy on the output of polite_directory_format,
    # and if the path doesn't start with $HOME, it returns the string it was given and strcpy tries to copy the string onto itself.
    # If you replace \w with $PWD — it should stop crashing
    PS1="\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[01;33m\]\$(scm_ps1)\[\033[00m\] \$ "
else
    PS1="[\u@\h \w]\$ "
fi
unset color_prompt force_color_prompt

# iTerm Tab and Title Customization and prompt customization
# http://sage.ucsc.edu/xtal/iterm_tab_customization.html

# Put the string " [bash]   hostname::/full/directory/path"
# in the title bar using the command sequence
# \[\e]2;[bash]   \h::\]$PWD\[\a\]

# Put the penultimate and current directory
# in the iterm tab
# \[\e]1;\]$(basename $(dirname $PWD))/\W\[\a\]

# vim: ts=4 sts=4 sw=4 et ai si syn=sh: