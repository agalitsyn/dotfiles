#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

sudo easy_install pip

pip install pyflakes pep8 pylint pep257 virtualenv mccabe
pip install Pygments Sphinx sphinxcontrib-seqdiag sphinxcontrib-blockdiag
