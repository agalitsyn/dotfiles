# two-agent-chat cookbook recipe: Codex strips AGTERM_SESSION_ID from tool subprocesses,
# so hand it over explicitly for peer-chat.py to find this session.
if [[ -n $AGTERM_SESSION_ID ]]; then
  function codex() { command codex -c "shell_environment_policy.set.AGTERM_SESSION_ID=\"$AGTERM_SESSION_ID\"" "$@" }
fi
