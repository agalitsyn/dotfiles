#!/bin/sh

set -x

apt-get install -y python \
                   python-dev

curl https://bootstrap.pypa.io/get-pip.py -o /opt/get-pip.py \
    && python /opt/get-pip.py

pip install ipython\
            flake8 \
            virtualenv \
            tox \
            pygments \
            Sphinx \
            sphinxcontrib-seqdiag \
            sphinxcontrib-blockdiag

