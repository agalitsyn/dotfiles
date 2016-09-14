#!/usr/bin/env/bash

set -xe

# Newest pip
if ! pip --version > /dev/null 2>&1; then
	curl --silent --show-error --location "https://bootstrap.pypa.io/get-pip.py" | sudo python
fi

sudo -H pip install --upgrade \
	pip \
	ipython \
	flake8 \
	tox \
	pygments \
	sphinx \
	sphinx-autobuild \
	sphinxcontrib-plantuml \
	sphinxcontrib-seqdiag \
	sphinxcontrib-blockdiag
