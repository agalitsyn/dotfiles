#!/usr/bin/env bash

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# OSX don't have git autocompletion and prompt
mkdir -pv ~/.bash/completion/git
curl -o ~/.bash/completion/git/git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.bash/completion/git/git-prompt.sh https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
