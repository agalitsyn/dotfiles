#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

which pip > /dev/null || echo "pip not found" && exit 1

sudo pip install pyflakes pep8 pylint pep257 virtualenv mccabe
sudo pip install Pygments Sphinx sphinxcontrib-seqdiag sphinxcontrib-blockdiag
