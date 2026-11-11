#!/bin/sh
# "Jira Ticket": show the Jira ticket of the session the chord fired in as a floating web page over
# it, and hide/show that page on the next presses. The key comes from the session name
# ("DL-7288 [repo]: summary", as jira-do-task-with-codex names it), else from the git branch of the pane's
# directory. The page uses the persistent browser store, so the Atlassian login survives closing
# the overlay and restarting agterm; --browse lets the login redirect leave the ticket's site.
# Run from keymap.conf, which exports AGT_SESSION_ID, AGT_SESSION_PWD and AGT_SOCKET.
set -eu

agt=/opt/homebrew/bin/agtermctl
jira=https://gfoundation.atlassian.net
sid=${AGT_SESSION_ID:?no session}
keyre='[A-Z][A-Z0-9]+-[0-9]+'

node=$("$agt" tree --json --socket "$AGT_SOCKET" |
  /usr/bin/jq -c --arg id "$sid" '[.. | objects | select(.id? == $id)][0]')

# A ticket page already in this session's slot, shown or hidden: flip it instead of opening another.
if printf '%s' "$node" | /usr/bin/jq -e --arg jira "$jira" \
  'any(.htmlOverlays[]?; (.pane == null) and ((.url // "") | startswith($jira)))' >/dev/null; then
  exec "$agt" session overlay toggle --target "$sid" --socket "$AGT_SOCKET"
fi

key=$(printf '%s' "$node" | /usr/bin/jq -r '.name // ""' | grep -oE "$keyre" | head -1 || true)
if [ -z "$key" ] && [ -d "${AGT_SESSION_PWD:-}" ]; then
  key=$(git -C "$AGT_SESSION_PWD" branch --show-current 2>/dev/null | grep -oE "$keyre" | head -1 || true)
fi
[ -n "$key" ] || { echo "no Jira key in the session name or the git branch" >&2; exit 1; }

exec "$agt" session overlay open --url "$jira/browse/$key" --js --persistent --browse --navigation \
  --size-percent 90 --target "$sid" --socket "$AGT_SOCKET"
