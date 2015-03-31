#!/bin/bash

set -x

# Awesome 3.5.*
add-apt-repository -y ppa:klaus-vormweg/awesome
apt-get update

apt-get install -y awesome

apt-get install -y lxappearance

apt-get install -y unclutter numlockx xscreensaver

apt-get install -y parcellite xsel xclip

apt-get install -y xfonts-terminus

apt-get install -y rxvt-unicode-256color xterm

