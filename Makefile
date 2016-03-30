# Some build target to reduce typing.
.DEFAULT_GOAL :=dryrun

VERBOSE=-vvv

# Check for syntax errors.
check:
	ansible-playbook $(VERBOSE) localhost.yml --syntax-check

# Test run the privisioning and unified diffs of the templates files.
dryrun:
	ansible-playbook $(VERBOSE) localhost.yml --check --diff --ask-sudo-pass --extra-vars package_update=false package_upgrade=false

# Getting information about the host machine, which is localhost.
facts:
	ansible all -m setup

# Privision the machine.
install:
	ansible-playbook $(VERBOSE) localhost.yml --ask-sudo-pass

install-fast:
	ansible-playbook $(VERBOSE) localhost.yml --ask-sudo-pass --skip-tags osx,package-manager

