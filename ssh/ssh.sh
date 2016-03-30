# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Delete host from known_hosts if node was reinstalled
function ssh-remove-from-known-hosts() {
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

# Copy specified ssh key to another machine
function ssh-copy-key() {
    local usage="Usage: ssh-copy-key {key} {host} {user}"
    local key="${1:?$usage}"
    local host="${2:?$usage}"
    local user="${3:?$usage}"

    cat "$key" | ssh "$host" -l "$user" "mkdir -pv ~/.ssh; cat - >> ~/.ssh/authorized_keys"
    echo "Use: ssh $host -l $user -i $key"
}

# Add record to ssh config
function ssh-set-config() {
    local usage="Usage: ssh-set-config {key} {host} {user}"
    local key="${1:?$usage}"
    local host="${2:?$usage}"
    local user="${3:?$usage}"

    cat >> ~/.ssh/config <<EOF
Host $host
User $user
IdentityFile $key

EOF
    echo "Use: ssh $host"
}

function wait-for-ssh() {
    local usage="Usage: wait-for-ssh {host} [user] [key] [timeout]"
    local host="${1:?$usage}"
    local user="$2"
    local key="$3"
    local timeout="${4:-10}"

    local command="ssh -o StrictHostKeyChecking=no $host"
    [ -n "$user" ] && command="$command -l $user"
    [ -n "$key" ] && command="$command -i $key"

    if ! timeout $timeout sh -c "while ! $command echo \"Success\"; do echo \"Retry ...\"; sleep 1; done"; then
        echo "Server didn't become ssh-able!" >&2
    fi
}
