#!/usr/bin/env/bash

set -xe

# see: https://pip.pypa.io/en/stable/installing/#id4
pip3 install --user --upgrade \
    pip \
    setuptools \
    ipython[all] \
    tox \
    pipenv \
    pgcli \
    pyjwt
