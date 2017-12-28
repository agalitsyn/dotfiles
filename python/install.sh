#!/usr/bin/env/bash

set -xe

# Newest pip
if ! pip3 --version > /dev/null 2>&1; then
	curl --silent --show-error --location "https://bootstrap.pypa.io/get-pip.py" | sudo python3
fi

sudo -H pip3 install --upgrade \
	pip \
	setuptools \
	ipython[all] \
	jupyter \
	flake8 \
	pylint \
	tox \
	debug \
	sh \
	plumbum \
	pygments \
	sphinx \
	sphinx-autobuild \
	sphinxcontrib-plantuml \
	sphinxcontrib-seqdiag \
	sphinxcontrib-blockdiag \
	pylint \
	jedi \
	mkdocs \
    pygments \
    neovim

# Pip for python2
if ! pip2 --version > /dev/null 2>&1; then
	curl --silent --show-error --location "https://bootstrap.pypa.io/get-pip.py" | sudo python2
fi

sudo -H pip2 install --upgrade \
	pip \
	setuptools \
	ipython

