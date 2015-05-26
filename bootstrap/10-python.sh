#!/bin/sh

set -x

apt-get install -y python python-dev python-pip python-setuptools python-virtualenv ipython
apt-get install -y python-tox python-flake8
apt-get install -y python-sphinx python-pygments python-sphinxcontrib.seqdiag python-sphinxcontrib.blockdiag

# update pip
curl -sSL https://bootstrap.pypa.io/get-pip.py | python
