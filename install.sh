#!/bin/bash
which git > /dev/null || ( echo 'Please, install git first.' && exit )

# Link new files and backup old
DIR=$PWD/`dirname $0`
cd `dirname $0`

for FILE in *; do
    [ "install.sh" = "$FILE" ] || [ "README.md" = "$FILE" ] || [ "fonts.conf" = "$FILE" ] && continue

    [ -f ~/.$FILE -a ! -h ~/.$FILE ] && mv ~/.$FILE ~/.$FILE.orig
    [ ! -f ~/.$FILE ] && ln -vsf $DIR/$FILE ~/.$FILE
done

cd ~
[ ! -d ~/bin ] && mkdir ~/bin

# https://github.com/rupa/z
if [ ! -e "$HOME/bin/z" ]; then
    git clone https://github.com/rupa/z.git ~/bin/z
    chmod +x ~/bin/z/z.sh
    # z binary is already referenced from .bash_profile
fi

# Vim
if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
    git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle"
    vim +BundleInstall +qall
fi