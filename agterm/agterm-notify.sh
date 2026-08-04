#!/usr/bin/env bash
# agterm-notify — a Claude Code hook wrapper that sets the agterm sidebar glyph and,
# when it is actually worth interrupting you, escalates to a sound + desktop banner.
#
#   agterm-notify.sh completed --auto-reset    # Stop hook: turn finished
#   agterm-notify.sh blocked --blink           # Notification hook: waiting on you
#
# The first arg is the agterm status state (idle|active|completed|blocked); everything
# after it is forwarded verbatim to `agtermctl session status` via the installed
# agent-status hook, which owns the --pane/--pane-id plumbing (a promoted split pane
# keeps a stale AGTERM_PANE, so we never re-implement that here).
#
# The glyph is ALWAYS set — it is passive, it costs you nothing. The sound and the
# banner are gated by should_notify() below, because the Stop hook fires on every
# single turn and an unconditional banner per turn is worse than no banner at all.
#
# Hook contract: never write to stdout (a UserPromptSubmit/SessionStart hook's stdout
# is injected into the prompt context) and always exit 0 (non-zero can block the turn).
set -u

STATUS_SH="$HOME/.config/agterm/agent-status/agterm-agent-status.sh"
AGTERMCTL="${AGTERMCTL:-/Applications/agterm.app/Contents/MacOS/agtermctl}"
SOUND="${AGTERM_NOTIFY_SOUND:-Submarine}"   # any name in /System/Library/Sounds, or "default"

[ -n "${AGTERM_SESSION_ID:-}" ] || exit 0   # not inside agterm: nothing to do

state=${1:-completed}
shift || true
hook_json=$(cat 2>/dev/null || true)        # Claude Code hands the hook its event on stdin

# ---------------------------------------------------------------------------
# Facts about the world, resolved once. Each is cheap and permission-free.
# ---------------------------------------------------------------------------

# The frontmost macOS application's display name, e.g. "agterm", "Helium".
# lsappinfo needs no Accessibility grant, unlike the System Events osascript route.
frontmost_app=$(lsappinfo info -only name "$(lsappinfo front 2>/dev/null)" 2>/dev/null |
  sed -n 's/.*"LSDisplayName"="\(.*\)"$/\1/p')

# One tree read answers the rest. idleMs = ms since the last user KEYSTROKE in the
# window; session_active = whether the user is currently looking at THIS session.
_tree=$("$AGTERMCTL" tree --json 2>/dev/null)
window_idle_ms=$(printf '%s' "$_tree" |
  jq -r '.result.tree.idleMs // 0' 2>/dev/null)
session_active=$(printf '%s' "$_tree" |
  jq -r --arg id "$AGTERM_SESSION_ID" \
    '[.result.tree.workspaces[].sessions[] | select(.id == $id) | .active] | first // false' 2>/dev/null)
: "${window_idle_ms:=0}" "${session_active:=false}"

# The Notification event carries the human-readable reason ("Claude needs your
# permission to use Bash"); the Stop event does not, so fall back to the cwd.
hook_message=$(printf '%s' "$hook_json" | jq -r '.message // empty' 2>/dev/null)
[ -n "$hook_message" ] || hook_message="Claude is ready in $(basename "$PWD")"

# ---------------------------------------------------------------------------
# TODO(you): the notification policy.
#
# Return 0 to escalate (sound + desktop banner), non-zero to stay silent and leave
# only the sidebar glyph. Available inputs:
#
#   $state             completed | blocked   (which hook fired)
#   $frontmost_app     "agterm" when agterm is the app you are looking at
#   $window_idle_ms    ms since your last keystroke in the agterm window
#   $session_active    "true" if this very session is the one selected in the sidebar
#
# Trade-offs to weigh:
#   - Gating on frontmost_app is the sharpest "am I even here" test, but you are still
#     interrupted for a 3-second turn you were waiting on with the window in the back.
#   - Gating on window_idle_ms catches "walked away" even while agterm is frontmost,
#     but a long turn where you sat reading the output looks identical to being gone.
#   - $state matters: a `blocked` permission prompt stalls all work until you answer,
#     while a `completed` turn is merely informational — they may deserve different bars.
#   - $session_active lets a background agent in another workspace shout while the
#     session you are actively watching stays quiet.
# ---------------------------------------------------------------------------
should_notify() {
  return 0   # placeholder: escalates on EVERY turn — replace with your policy
}

should_notify || { "$STATUS_SH" "$state" "$@" >/dev/null 2>&1; exit 0; }

# Escalate: re-assert the glyph with a one-shot sound, then post the banner (which also
# raises the session's unseen badge, cleared by `agtermctl session seen`).
"$STATUS_SH" "$state" --sound "$SOUND" "$@" >/dev/null 2>&1
"$AGTERMCTL" notify "$hook_message" \
  --title "Claude · $(basename "$PWD")" \
  --target "$AGTERM_SESSION_ID" >/dev/null 2>&1

exit 0
