#!/bin/sh

set -x

# Ask for the administrator password upfront.
sudo -v

which pip > /dev/null || (echo "pip not found" && exit 1)

# Essentials
pip install ipython pyflakes pep8 pylint pep257 virtualenv
# Sphinx ans others
pip install Pygments Sphinx sphinxcontrib-seqdiag sphinxcontrib-blockdiag
