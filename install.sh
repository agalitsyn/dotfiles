#!/bin/bash
which git > /dev/null || ( echo 'Git not found.' && exit )
which easy_install > /dev/null || ( echo 'easy_install not found (install python-setuptools).' && exit )

# Link new files and backup old
DIR=$PWD/`dirname $0`
cd `dirname $0`

excluded=(install.sh README.md fonts.conf osx ubuntu_packages)
for FILE in *; do
	if [[ ! ${excluded[*]} =~ "$FILE" ]]; then
		[ -f ~/.$FILE -a ! -h ~/.$FILE ] && mv ~/.$FILE ~/.$FILE.orig
    	[ ! -f ~/.$FILE ] && ln -vsf $DIR/$FILE ~/.$FILE
	fi
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

# for the c alias (syntax highlighted cat)
# Python is required
sudo easy_install Pygments