alias cc="claude"
alias ccw="claude --worktree"

# After an interactive session ends, push "claude --resume <id>" into history,
# so arrow-up brings it back. The id comes from the SessionEnd hook in
# settings.json, which writes it to $CLAUDE_LAST_SESSION_FILE. Nested claude
# processes inherit both variables; the hook skips them because their parent
# is not $CLAUDE_LAST_SESSION_SHELL.
claude() {
  if (( ${@[(I)-p|--print]} )); then
    command claude "$@"
    return
  fi

  local session_file rc session_id
  session_file=$(mktemp "${TMPDIR:-/tmp}/claude-session.XXXXXX") || { command claude "$@"; return }
  CLAUDE_LAST_SESSION_FILE=$session_file CLAUDE_LAST_SESSION_SHELL=$$ command claude "$@"
  rc=$?
  session_id=$(<"$session_file")
  rm -f -- "$session_file"
  [[ -n $session_id ]] && print -s -- "claude --resume $session_id"
  return rc
}
