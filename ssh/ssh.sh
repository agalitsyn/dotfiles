# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# If iTerm is detected these themes are used for regular windows
# and ssh respectively
ITERM_NORMAL_PROFILE='Fancy'
ITERM_SSH_PROFILE='DarkSSH'

# On iTerm we switch terminals for SSH if we have it.  This switches to
# the SSH profile and back when ssh is run from the terminal.
if [[ "$TERM_PROGRAM" == iTerm.app ]]; then
  function ssh() {
    echo -n -e $'\033]50;SetProfile='$ITERM_SSH_PROFILE'\a'
    command ssh "$@"
    echo -n -e $'\033]50;SetProfile='$ITERM_NORMAL_PROFILE'\a'
  }
fi

# Delete host from known_hosts if node was reinstalled
ssh-remove-from-known-hosts() {
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

# Dumb poller
wait-for-ssh() {
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
