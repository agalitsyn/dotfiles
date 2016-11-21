# autocomplete for 'g' as well
# see http://nuclearsquid.com/writings/git-tricks-tips-workflows/
alias g='git'
[ -f "/usr/share/bash-completion/completions/git" ] && source /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g

git-delete-merged-branches() {
    git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}
