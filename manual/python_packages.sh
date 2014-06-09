#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

# For Ubuntu it installed from package
which pip > /dev/null || sudo easy_install pip

sudo pip install pyflakes pep8 pylint pep257 virtualenv mccabe
sudo pip install Pygments Sphinx sphinxcontrib-seqdiag sphinxcontrib-blockdiag
