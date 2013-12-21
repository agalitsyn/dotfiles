#!/usr/bin/env bash

# homebrew
ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to clipboard
bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# https://rvm.io
curl -L https://get.rvm.io | bash -s stable --ruby

# https://github.com/isaacs/nave
# needs npm, obviously.
npm install -g nave

# Shameless osx don't have git autocompletion and prompt
curl -o ~/.git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh