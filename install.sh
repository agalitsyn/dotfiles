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
         file="$(basename $path)"
        [ -f "$HOME/.$file" -a ! -h "$HOME/.$file" ] && mv "$HOME/.$file" "$HOME/.$file.orig"
        [ ! -f "$HOME/.$file" ] && ln -vsf "$dotfiles/$path" "$HOME/.$file"
    done
}

# Main logic
which git > /dev/null || die 'git is not found.'
which vim > /dev/null || die 'vim is not found.'
which curl > /dev/null || die 'curl is not found.'

dotfiles="$PWD/`dirname $0`"
cd "`dirname $0`"

link 'bash'
link 'vim'
link 'git'
link 'zsh'

[ ! -d "$HOME/bin" ] && mkdir -v "$HOME/bin"

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

# Sublime text 3
sublime_config="$HOME/.config/sublime-text-3"
mkdir -pv $sublime_config/Packages/User
curl "http://sublime.wbond.net/Package%20Control.sublime-package" > "$sublime_config/Packages/User/Package\ Control.sublime-package"
cp $dotfiles/config/sublime-text-3/* $sublime_config/

# Create projects folder and useful symlink
projects_path="$HOME/Projects"
tools_path="$projects_path/Tools"
if [ ! -e "$projects_path" ]; then
    mkdir -pv $tools_path
    ln -sv "$projects_path" "$HOME/prj"
fi

# Solarized colorscheme
if [ ! -e "$tools_path/solarized" ]; then
    git clone https://github.com/altercation/solarized.git "$tools_path/solarized"
fi

if [ "$OSTYPE" = 'linux-gnu' ]; then
    # fix for "ls"
    cd
    wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
    mv dircolors.ansi-dark .dircolors
    eval `dircolors ~/.dircolors`
    # set colors for gnome ternimal
    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git "$tools_path/gnome-terminal-colors-solarized"
    exec "$tools_path/gnome-terminal-colors-solarized/set_dark.sh"
fi
