#!/usr/bin/env bash

# Shell prompt based on the Solarized Dark theme.
# Screenshot: http://i.imgur.com/EkEtphC.png
# Heavily inspired by @necolas’s prompt: https://github.com/necolas/dotfiles
# iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

set_prompt() {
	local return_code="$?"
	local ret_code=""
    local hostStyle=""
    local userStyle=""

	local bold="";
	local reset="\e[0m";
	local magenta="\e[38;5;5m"
	local black="\e[1;30m";
	local blue="\e[1;34m";
	local cyan="\e[1;36m";
	local green="\e[38;5;2m";
	local orange="\e[38;5;3m";
	local purple="\e[1;35m";
	local red="\e[1;31m";
	local violet="\e[1;35m";
	local white="\e[38;5;7m";
	local yellow="\e[1;33m";

	# Highlight the user name when logged in as root.
	if [[ "${USER}" == "root" ]]; then
		userStyle="${red}";
	else
		userStyle="${magenta}";
	fi;

	# Highlight the hostname when connected via SSH.
	if [[ "${SSH_TTY}" ]]; then
		hostStyle="${bold}${red}";
	else
		hostStyle="${orange}";
	fi;

	if [[ $return_code != 0 ]]; then
		ret_code="\[${red}\]${return_code}\[${reset}\]"
	fi;

	# Set the terminal title and prompt.
	PS1="\[\033]0;\W\007\]"; # working directory base name
	PS1+="\n"; # newline
	PS1+="\[${white}\]\t | "; # time
	PS1+="\[${userStyle}\]\u"; # username
	PS1+="\[${white}\] at ";
	PS1+="\[${hostStyle}\]\h"; # host
	PS1+="\[${white}\] in ";
	PS1+="\[${green}\]\w"; # working directory full path
	PS1+="\$(prompt_git \"\[${white}\] on \[${white}\]\" \"\[${blue}\]\") "; # Git repository details
	PS1+="\[${ret_code}\]"; # err code
	PS1+="\n";
	PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
	export PS1;

	PS2="\[${yellow}\]→ \[${reset}\]";
	export PS2;
}

export PROMPT_COMMAND=set_prompt
