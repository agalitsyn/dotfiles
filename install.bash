#!/usr/bin/env bash

which git > /dev/null || ( echo 'Git not found.' && exit )
which easy_install > /dev/null || ( echo 'easy_install not found (install python-setuptools).' && exit )

function link() {
    local file
    for path in $1/*; do
        file=$(basename $path)

        [ -f $HOME/.$file -a ! -h $HOME/.$file ] && mv $HOME/.$file $HOME/.$file.orig
        [ ! -f $HOME/.$file ] && ln -vsf $dir/$path $HOME/.$file
    done
}

# Link new files and backup old
dir=$PWD/`dirname $0`
cd `dirname $0`

link 'bash'
link 'vim'
link 'git'
link 'rc'
link 'tools'

cd $HOME
[ ! -d $HOME/bin ] && mkdir $HOME/bin

# https://github.com/rupa/z
if [ ! -e "$HOME/bin/z" ]; then
    git clone https://github.com/rupa/z.git $HOME/bin/z
    chmod +x $HOME/bin/z/z.sh
    # z binary is already referenced from .bash_profile
fi

# Vim
if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
    git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle"
    vim +BundleInstall +qall
fi

# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to clipboard
sudo bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# for the c alias (syntax highlighted cat)
# Python is required
sudo easy_install Pygments
