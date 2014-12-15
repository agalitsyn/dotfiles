#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

which pip > /dev/null || echo "pip not found" && exit 1

# Essentials
sudo pip install ipython pyflakes pep8 pylint pep257 virtualenv
# Sphinx ans others
sudo pip install Pygments Sphinx sphinxcontrib-seqdiag sphinxcontrib-blockdiag
