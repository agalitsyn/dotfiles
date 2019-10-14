# colored cat
alias c='pygmentize -O style=monokai -f console256 -g'

# search with pager
alias agp="ag --pager='less -XFR'"

function rgp() {
  rg -p "$@" | less -XFR
}

# Create a new directory and enter it
mkd() {
    mkdir -pv "$@" && cd "$@"
}

# find shorthand
f() {
    find . -name "$1"
}

# Goto temp dir
cdt() {
    [ -z "$TMPDIR" ] && cd /tmp || cd "$TMPDIR"
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Simple calculator
calc() {
	local result=""
	result="$(printf "scale=10;%s\\n" "$*" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		# add "0" for cases like ".5"
		# add "0" for cases like "-.5"
		# remove trailing zeros
		printf "%s" "$result" |
			sed -e 's/^\./0./'  \
			-e 's/^-\./-0./' \
			-e 's/0*$//;s/\.$//'
	else
		printf "%s" "$result"
	fi
	printf "\\n"
}

