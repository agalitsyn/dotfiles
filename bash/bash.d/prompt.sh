function prompt_command {
    local RETURN_CODE="$?"

    # dark, light, bold
    local Rd="\[\e[0;31m\]"; local R="\[\e[0;91m\]"; local Rb="\[\e[1;31m\]"
    local Gd="\[\e[0;32m\]"; local G="\[\e[0;92m\]"; local Gb="\[\e[1;32m\]"
    local Yd="\[\e[0;33m\]"; local Y="\[\e[0;93m\]"; local Yb="\[\e[1;33m\]"
    local Bd="\[\e[0;34m\]"; local B="\[\e[0;94m\]"; local Bb="\[\e[1;34m\]"
    local Pd="\[\e[0;35m\]"; local P="\[\e[0;95m\]"; local Pb="\[\e[1;35m\]"
    local Cd="\[\e[0;36m\]"; local C="\[\e[0;96m\]"; local Cb="\[\e[1;36m\]"

    if [[ $TERM == 'linux' ]] ; then
        R=$Rb
        G=$Gb
        Y=$Yb
        B=$Bb
        P=$Pb
        C=$Cb
    fi

    local BOLD="\[\e[1m\]"
    local RESET="\[\e[0m\]"

    local TIME="${G}\t${RESET}"

    if [[ $RETURN_CODE != 0 ]] ; then
        local RETCODE="${R}${RETURN_CODE}${RESET} "
    fi

    if [[ $EUID == 0 ]] ; then
        local PROMPT_COLOR="$R"

        # getting hg and git info is disabled for root
        local HG_INFO=" ${P}-${RESET}"
        local GIT_INFO=" ${G}-${RESET}"
    else
        local PROMPT_COLOR="$G"

        case "$(_upsearch)" in
            'hg')
                local HG_INFO=
                _set_hg_info
                ;;
            'git')
                local GIT_INFO=
                _set_git_info
                ;;
        esac
    fi

    if [[ $VIRTUAL_ENV ]] ; then
        local VENV="${G}+"$(basename "$VIRTUAL_ENV")"${RESET}"
    fi

    PS1="\
[${TIME} \u@\h \
${RETCODE}\W${VENV}${HG_INFO}${GIT_INFO}]\
${PROMPT_COLOR}\\\$${RESET} "
}

function _upsearch {
    test "$PWD" == '/' && return || test -e '.hg' && echo 'hg' && return || test -e '.git' && echo 'git' && return || cd .. && _upsearch
}

function _set_hg_info {
    if [[ $USE_HG_PROMPT ]] ; then
        local PROMPT_TEMPLATE="${P}{branch|quiet}{${Rd}{closed}}${P}â˜¿{rev}{${B}+{tags|quiet|+}}{${Gd}*{bookmark}}{${R}{update}}{${G}+{rev|merge}}${R}{status|modified}${RESET}"
        HG_INFO=" $(hg prompt $PROMPT_TEMPLATE)"
    else
        local SUM=$(LC_ALL=C hg sum 2>/dev/null)
        local PARENTS=($(grep -Po '(?<=parent: ).*(?=:)' <<< "$SUM"))
        local BRANCH=$(grep -Po '(?<=branch: ).*$' <<< "$SUM")
        local COMMIT=$(grep -Po '(?<=commit: ).*$' <<< "$SUM")
        local UPDATE=$(grep -Po '(?<=update: ).*$' <<< "$SUM")

        local REV=${PARENTS[0]}
        local MERGEREV=${PARENTS[1]}

        BRANCH=${BRANCH/default/}
        [ -z "$MERGEREV" ] || MERGEREV="+$MERGEREV"
        case "$COMMIT" in
            *'(clean)'*)
                COMMIT=''
                ;;
            *added*|*modified*|*deleted*)
                COMMIT='!'
                ;;
        esac
        case "$UPDATE" in
            *'(update)'*)
                UPDATE='^'
                ;;
            *'(merge)'*)
                UPDATE=''
                ;;
            *'(current)'*)
                UPDATE=''
                ;;
        esac
        HG_INFO=" ${P}${BRANCH}â˜¿${REV}${R}${UPDATE}${G}${MERGEREV}${R}${COMMIT}${RESET}"
    fi
}

function _set_git_info {
    local STATUS=$(LC_ALL=C git status 2>/dev/null)
    local BRANCH=$(grep -Po '(?<=On branch ).*$' <<< "$STATUS")
    local REV=$(LC_ALL=C git rev-parse --short HEAD 2>/dev/null)
    local MERGEREV=$(LC_ALL=C git rev-parse --short MERGE_HEAD 2>/dev/null)
    local STASH=$(LC_ALL=C git stash list 2>/dev/null)

    if [[ $STATUS == *'Your branch is behind'* ]] ; then
        local BEHIND="$R^"
        [[ $STATUS =~ 'behind '[^$'\n']+' '([0-9]+)' commit' ]] && BEHIND+=${BASH_REMATCH[1]}
    fi
    if [[ $STATUS == *'Your branch is ahead'* ]] ; then
        local AHEAD="$Y^"
        [[ $STATUS =~ 'ahead '[^$'\n']+' '([0-9]+)' commit' ]] && AHEAD+=${BASH_REMATCH[1]}
    fi
    if [[ $STATUS == *detached* ]] ; then
        REV="$P$REV"
    else
        REV="$G$REV"
    fi
    if [[ $STATUS == *'Changes to be committed'* ]] ; then
        local STAGED="$R!"
    fi
    if [[ $STATUS == *'Changes not staged'* ]] ; then
        local UNSTAGED="$P?"
    fi
    if [[ $STATUS == *'You have unmerged paths.'* ]] ; then
        local MERGE="$R+$MERGEREV"
    fi
    if [[ $STATUS == *'All conflicts fixed but you are still merging.'* ]] ; then
        local MERGE="$B+$MERGEREV"
    fi
    if [[ ! -z $STASH ]] ; then
        STASH='S'
    fi

    GIT_INFO=" ${G}${BRANCH} ${REV}${MERGE}${BEHIND}${AHEAD}${STAGED}${UNSTAGED}${C}${STASH}${RESET}"
}

# first find prompt in hgrc, then check it's actually enabled
if grep -w '^prompt' ~/.hgrc &>/dev/null && hg help prompt &>/dev/null ; then
    USE_HG_PROMPT=1
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROMPT_COMMAND=prompt_command

# iTerm Tab and Title Customization and prompt customization
# http://sage.ucsc.edu/xtal/iterm_tab_customization.html
#
# Put the string " [bash]   hostname::/full/directory/path"
# in the title bar using the command sequence
# \[\e]2;[bash]   \h::\]$PWD\[\a\]
#
# Put the penultimate and current directory
# in the iterm tab
# \[\e]1;\]$(basename $(dirname $PWD))/\W\[\a\]
