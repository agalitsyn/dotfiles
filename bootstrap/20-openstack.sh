#!/usr/bin/env bash

set -xe

apt-get install -y --no-install-recommends libffi-dev \
                                           libssl-dev \
                                           gcc \
                                           python-dev

BASH_COMPLETION_DIR="/etc/bash_completion.d"

# Old clients
clients=( nova neutron glance cinder keystone designate heat trove ceilometer )
for client in "${clients[@]}"; do
    pip install --upgrade python-${client}client

    cat <<"EOF" > $BASH_COMPLETION_DIR/$client
_%%CLIENT%%()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(%%CLIENT%% bash-completion)"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F _%%CLIENT%% %%CLIENT%%
EOF
    sed -i "s/%%CLIENT%%/$client/g" $BASH_COMPLETION_DIR/$client
done

# New client
openstack complete  > $BASH_COMPLETION_DIR/openstack
