#!/usr/bin/env/bash

set -xe

pip3 install --user --upgrade \
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
	mkdocs \
    pyjwt \
    requests \
    jinja2 \
    fake-useragent \
    beautifulsoup4

