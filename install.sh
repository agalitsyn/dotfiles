#!/bin/sh

set -e

die()
{
    echo "ERROR: $*" >&2
    exit 1
}

link()
{
    local file
    for path in $1/*; do
        file=$(basename $path)
        [ -f $HOME/.$file -a ! -h $HOME/.$file ] && mv $HOME/.$file $HOME/.$file.orig
        [ ! -f $HOME/.$file ] && ln -vsf $dir/$path $HOME/.$file
    done
}

# Main logic
which git > /dev/null || die 'Git not found.'

dir=$PWD/`dirname $0`
cd `dirname $0`

link 'bash'
link 'vim'
link 'git'
link 'zsh'

[ ! -d $HOME/bin ] && mkdir $HOME/bin

# https://github.com/rupa/z
if [ ! -e "$HOME/bin/z" ]; then
    git clone https://github.com/rupa/z.git $HOME/bin/z
    chmod +x $HOME/bin/z/z.sh
    # z binary is already referenced from .bash_profile
fi

# vim
if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
    git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle"
    vim +BundleInstall +qall
fi