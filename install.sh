#!/bin/sh
# vim: ts=4 sts=4 sw=4 noet:

set -e

die()
{
    echo "ERROR: $*" >&2
    exit 1
}

announce_step()
{
    echo
    echo "===> $*"
    echo
}

usage()
{
    cat >&2 <<EOT
Usage: $0 [--vim --sublime --solarized]

Each flag activates additional configuration.
EOT
    exit 2
}

end()
{
    announce_step "DONE."
}

check_dependencies()
{
    announce_step "Check dependencies"

    which git > /dev/null || die 'git is not found.'
    which vim > /dev/null || die 'vim is not found.'
    which curl > /dev/null || die 'curl is not found.'
}

prepare_folders()
{
    announce_step "Prepare folders"

    # Create bin dir
    [ ! -d "$HOME/bin" ] && mkdir -v "$HOME/bin"

    # Create projects folder and useful symlink
    local projects_path="$HOME/Projects"
    local tools_path="$projects_path/Tools"
    if [ ! -e "$projects_path" ]; then
        mkdir -pv $tools_path
        ln -sv "$projects_path" "$HOME/prj"
    fi
}

link_config()
{
    local folder="$1"
    local file

    for path in $(find $folder -name '.*'); do
        file="$(basename $path)"
        [ -f "$HOME/$file" -a ! -h "$HOME/$file" ] && mv "$HOME/$file" "$HOME/$file.orig"
        [ ! -f "$HOME/$file" ] && ln -vsf "$DOTFILES_D/$path" "$HOME/$file"
    done
}

install_z()
{
    announce_step "Install https://github.com/rupa/z"

    if [ ! -e "$HOME/bin/z" ]; then
        git clone https://github.com/rupa/z.git $HOME/bin/z
        chmod +x $HOME/bin/z/z.sh
        # z binary is already referenced from .bash_profile
    fi
}

install_solarized_colors()
{
    announce_step "Install solarized color scheme"

    if [ ! -e "$tools_path/solarized" ]; then
        git clone https://github.com/altercation/solarized.git "$tools_path/solarized"
        git clone https://github.com/peel/mc.git "$tools_path/mc-solarized"
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
}

configure_vim()
{
    announce_step "Configure VIM"

    link_config "vim"

    if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
        git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle"
        vim +BundleInstall +qall
    fi
}

configure_sublime_text()
{
    announce_step "Configure Sublime Text 3"

    local sublime_config="$HOME/.config/sublime-text-3"
    [ "$OSTYPE" = "linux-gnu" ] || sublime_config="$HOME/Library/Application Support/Sublime\ Text\ 3/"

    mkdir -pv $sublime_config/Packages/User
    curl "http://sublime.wbond.net/Package%20Control.sublime-package" > "$sublime_config/Packages/User/Package\ Control.sublime-package"
    cp $DOTFILES_D/config/sublime-text-3/* $sublime_config/
}

# Constants

DOTFILES_D="$PWD/`dirname $0`"

# Parse args

opt_configure_vim=
opt_configure_sublime=
opt_install_solarized=

while [ "$#" -gt 0 ]; do
    case "$1" in
        --vim)
            opt_configure_vim="true"
            shift
            ;;
        --sublime)
            opt_configure_sublime="true"
            shift
            ;;
        --solarized)
            opt_install_solarized="true"
            shift
            ;;
        --help)
            usage
            shift
            ;;
        *)
            die "Unknown option: $1"
    esac
done

# Main logic

announce_step "Begin configuring ..."

cd $DOTFILES_D

check_dependencies
prepare_folders

link_config "bash"
link_config "git"
link_config "rc"

install_z

[ -z "$opt_configure_sublime" ] || configure_sublime_text
[ -z "$opt_configure_vim" ] || configure_vim
[ -z "$opt_install_solarized" ] || install_solarized_colors

end
