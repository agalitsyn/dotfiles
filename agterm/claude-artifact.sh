#!/bin/sh
# "Claude Artifact": show a claude.ai artifact of the Claude Code conversation running in the session
# the command fired in as a floating web page over it, and hide/show that page on the next runs.
# The conversation is found through ~/.claude/sessions/<pid>.json of a live claude process whose
# environment carries this AGTERM_SESSION_ID (a split or scratch claude counts too); its transcript
# names every artifact the Artifact tool published, opened or read. One artifact opens at once,
# several go through a picker, newest first. The page uses the persistent browser store, so the
# claude.ai login survives closing the overlay and restarting agterm; --browse lets the login
# redirect leave claude.ai.
# Run from keymap.conf, which exports AGT_SESSION_ID and AGT_SOCKET.
set -eu

agt=/opt/homebrew/bin/agtermctl
jq=/usr/bin/jq
site=https://claude.ai/
sid=${AGT_SESSION_ID:?no session}

node=$("$agt" tree --json --socket "$AGT_SOCKET" |
  "$jq" -c --arg id "$sid" '[.. | objects | select(.id? == $id)][0]')

# An artifact page already in this session's slot, shown or hidden: flip it instead of opening another.
if printf '%s' "$node" | "$jq" -e --arg site "$site" \
  'any(.htmlOverlays[]?; (.pane == null) and ((.url // "") | startswith($site)))' >/dev/null; then
  exec "$agt" session overlay toggle --target "$sid" --socket "$AGT_SOCKET"
fi

set --
for f in "$HOME"/.claude/sessions/*.json; do
  [ -f "$f" ] || continue
  pid=$(basename "$f" .json)
  ps eww -o command= -p "$pid" 2>/dev/null | /usr/bin/grep -qE "AGTERM_SESSION_ID=$sid( |\$)" || continue
  conv=$("$jq" -r '.sessionId // empty' "$f")
  for t in "$HOME"/.claude/projects/*/"$conv".jsonl; do
    [ -f "$t" ] && set -- "$@" "$t"
  done
done
[ $# -gt 0 ] || { echo "no Claude Code conversation runs in this session" >&2; exit 1; }

items=$(/usr/bin/grep -hF 'claude.ai/' "$@" | "$jq" -c '
  select(.toolUseResult | type == "object")
  | {url: .toolUseResult.url, title: (.toolUseResult.title // ""), ts: .timestamp}
  | select((.url // "") | test("^https://claude\\.ai/(code/)?artifact/[A-Za-z0-9_-]+$"))' |
  "$jq" -sc 'sort_by(.ts) | reverse | unique_by(.url) | sort_by(.ts) | reverse')

case $(printf '%s' "$items" | "$jq" length) in
0)
  echo "no artifacts in this session's Claude conversation" >&2
  exit 1
  ;;
1)
  url=$(printf '%s' "$items" | "$jq" -r '.[0].url')
  ;;
*)
  answer=$(printf '%s' "$items" | "$jq" -c '[.[] | {
      id: .url,
      label: (if .title == "" then .url else .title end),
      subtitle: "\(.ts | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601 | strflocaltime("%d.%m %H:%M")) · \(.url)"
    }]' | "$agt" pick --prompt "Artifact" --socket "$AGT_SOCKET") || exit 0
  url=$(printf '%s' "$answer" | "$jq" -r '.id // empty')
  [ -n "$url" ] || exit 0
  ;;
esac

exec "$agt" session overlay open --url "$url" --js --persistent --browse --navigation \
  --size-percent 90 --target "$sid" --socket "$AGT_SOCKET"
