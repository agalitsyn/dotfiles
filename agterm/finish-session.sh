#!/bin/sh
# "Finish Work": close the session the chord fired in, both panes and everything running in them
# (claude, codex, their child processes), after one confirmation. Unlike cmd+w this is not undoable:
# a single-target `session close` without --undoable kills the zmx daemons at once, so nothing
# lingers through the undo grace period. Run from keymap.conf, which exports AGT_SESSION_ID and
# AGT_SOCKET.
#
# When the session is rooted in a ticket worktree (<repo>/.claude/worktrees/<KEY>, made by the
# jira-do-task-with-codex skill), the worktree is removed too, but only when nothing would be lost:
# no uncommitted or untracked files, and HEAD is on some remote branch. Otherwise the dialog says why
# it stays. The branch is always kept.
set -eu

agt=/opt/homebrew/bin/agtermctl
sid=${AGT_SESSION_ID:?no session}

node=$("$agt" tree --json --socket "$AGT_SOCKET" |
  /usr/bin/jq -c --arg id "$sid" '[.. | objects | select(.id? == $id)][0]')
name=$(printf '%s' "$node" | /usr/bin/jq -r '.name // "session"')
running=$(printf '%s' "$node" | /usr/bin/jq -r '[(.foreground // [])[0], (.splitForeground // [])[0]] | map(select(.)) | join(", ")')
cwd=$(printf '%s' "$node" | /usr/bin/jq -r '.cwd // empty')

worktree=
main=
note=
top=$([ -n "$cwd" ] && git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || true)
case "$top" in
*/.claude/worktrees/*)
  main=$(git -C "$top" worktree list --porcelain | sed -n '1s/^worktree //p')
  dirty=$(git -C "$top" status --porcelain | wc -l | tr -d ' ')
  if [ "$dirty" != 0 ]; then
    note="The worktree stays: $dirty uncommitted or untracked files."
  elif [ -z "$(git -C "$top" branch -r --contains HEAD 2>/dev/null)" ]; then
    note="The worktree stays: HEAD is not pushed."
  else
    worktree=$top
    note="The worktree ${top#"$main"/} will be removed, the branch stays."
  fi
  ;;
esac

answer=$("$agt" ask "Finish work?" --target "$sid" \
  --message "Close \"$name\" and kill ${running:-its shells}. This cannot be undone.${note:+ $note}" \
  --button close=Finish --button cancel=Cancel --default close \
  --hotkey close=f --hotkey cancel=c \
  --socket "$AGT_SOCKET") || exit 0
[ "$(printf '%s' "$answer" | /usr/bin/jq -r .id)" = close ] || exit 0

"$agt" session close --target "$sid" --socket "$AGT_SOCKET" >/dev/null

[ -n "$worktree" ] || exit 0
# Without --force git refuses a worktree that got dirty after the check above.
if ! err=$(git -C "$main" worktree remove "$worktree" 2>&1); then
  "$agt" notify "$err" --title "Worktree kept" --socket "$AGT_SOCKET" >/dev/null || true
fi
