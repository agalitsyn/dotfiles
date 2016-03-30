#!/usr/bin/env bash

# Prerequisite before we can setup and config our system until I can figure a
# way to bypass this. Currently only RPM-based and DEB-based GNU/Linux distros
# are supported.

# Newer distro like Fedora 23 does not install Python 2.X by default as they
# fully embraced Python 3.
DEFAULT_PYTHON='python'
[ -n $(command -v python) ] && DEFAULT_PYTHON='python3'

DEFAULT_REPO_PATH="$HOME/Projects"

function git_clone_and_ansible_ping() {
    mkdir $DEFAULT_REPO_PATH
    cd $DEFAULT_REPO_PATH
    git clone https://github.com/kianmeng/dotfiles-ansible.git
    cd dotfiles-ansible
    ansible all -m ping
}

function install_ansible_and_git() {
    if [[ $($DEFAULT_PYTHON -mplatform | grep -Ei 'ubuntu|debian') ]];
    then
        sudo apt-add-repository -y ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install -y ansible git make
    elif [[ $($DEFAULT_PYTHON -mplatform | grep -Ei 'fedora|centos') ]];
    then
        sudo yum install -y epel-release
        sudo yum install -y ansible ansible-lint git make
    else
        echo -e "Error: Only RPM-based or DEB-based GNU/Linux distros are supported."
        exit 1
    fi
}

install_ansible_and_git && git_clone_and_ansible_ping
