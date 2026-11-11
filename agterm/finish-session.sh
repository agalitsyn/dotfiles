#!/bin/sh
# "Finish Work": close the session the chord fired in, both panes and everything running in them
# (claude, codex, their child processes), after one confirmation. Unlike cmd+w this is not undoable:
# a single-target `session close` without --undoable kills the zmx daemons at once, so nothing
# lingers through the undo grace period. Run from keymap.conf, which exports AGT_SESSION_ID and
# AGT_SOCKET.
set -eu

agt=/opt/homebrew/bin/agtermctl
sid=${AGT_SESSION_ID:?no session}

node=$("$agt" tree --json --socket "$AGT_SOCKET" |
  /usr/bin/jq -c --arg id "$sid" '[.. | objects | select(.id? == $id)][0]')
name=$(printf '%s' "$node" | /usr/bin/jq -r '.name // "session"')
running=$(printf '%s' "$node" | /usr/bin/jq -r '[(.foreground // [])[0], (.splitForeground // [])[0]] | map(select(.)) | join(", ")')

answer=$("$agt" ask "Finish work?" --target "$sid" \
  --message "Close \"$name\" and kill ${running:-its shells}. This cannot be undone." \
  --button close=Finish --button cancel=Cancel --default close \
  --hotkey close=f --hotkey cancel=c \
  --socket "$AGT_SOCKET") || exit 0
[ "$(printf '%s' "$answer" | /usr/bin/jq -r .id)" = close ] || exit 0

"$agt" session close --target "$sid" --socket "$AGT_SOCKET" >/dev/null
