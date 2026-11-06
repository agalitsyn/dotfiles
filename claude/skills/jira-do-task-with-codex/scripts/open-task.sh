#!/usr/bin/env bash
# Open a Jira ticket as a new agterm session next to the caller's: a git worktree on a fresh
# default branch, Codex in the right pane of a vertical split, then Claude in the left pane with
# the planning prompt. Prints the new session id and the worktree path.
set -euo pipefail

usage='usage: open-task.sh <jira-url> [--repo DIR] [--plan FILE]'
url='' repo=$PWD plan=''
while (($#)); do
  case $1 in
    --repo) repo=${2:?$usage}; shift 2 ;;
    --repo=*) repo=${1#*=}; shift ;;
    --plan) plan=${2:?$usage}; shift 2 ;;
    --plan=*) plan=${1#*=}; shift ;;
    -*) echo "$usage" >&2; exit 2 ;;
    *) [[ -z $url ]] || { echo "$usage" >&2; exit 2; }; url=$1; shift ;;
  esac
done
[[ -n $url ]] || { echo "$usage" >&2; exit 2; }
# The URL ends up inside a single-quoted shell line typed into the pane.
[[ $url =~ ^https?://[A-Za-z0-9./:_?=\&%#-]+$ ]] || { echo "not a plain Jira URL: $url" >&2; exit 2; }
key=$(grep -oE '[A-Z][A-Z0-9]+-[0-9]+' <<<"$url" | head -1 || true)
[[ -n $key ]] || { echo "no ticket key in: $url" >&2; exit 2; }
[[ ${AGTERM_ENABLED:-} == 1 && -n ${AGTERM_SESSION_ID:-} ]] || { echo "not inside an agterm session" >&2; exit 2; }
[[ -z $plan || -s $plan ]] || { echo "plan file missing or empty: $plan" >&2; exit 2; }
[[ -d $repo ]] || { echo "not a directory: $repo" >&2; exit 2; }

common=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
  echo "not a git repository: $repo" >&2
  exit 2
}
# The main checkout, even when called from inside another worktree.
root=$(dirname "$common")

# A plan made in the calling session goes to a stable place: that session's scratchpad dies with it.
if [[ -n $plan ]]; then
  plan_dst=$HOME/.claude/plans/$key.md
  # The path ends up inside the single-quoted prompt typed into the pane.
  [[ $plan_dst != *"'"* ]] || { echo "plan path has a quote: $plan_dst" >&2; exit 2; }
  mkdir -p "$(dirname "$plan_dst")"
  [[ ! -e $plan_dst ]] || echo "overwriting earlier plan $plan_dst" >&2
  cp -- "$plan" "$plan_dst"
fi

cd "$root"

default=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true)
default=${default#origin/}
if [[ -z $default ]]; then
  for b in main master; do
    git show-ref --verify --quiet "refs/remotes/origin/$b" && { default=$b; break; }
  done
fi
[[ -n $default ]] || { echo "cannot find origin's main or master branch" >&2; exit 2; }

summary=$(acli jira workitem view "$key" --fields summary --json | jq -er '.fields.summary')
if [[ -n $plan ]]; then
  prompt="План по тикету $url уже составлен и согласован с пользователем и Codex: $plan_dst. Прочти его и выполняй вместе с codex. Заново тикет не планируй; открывай его, только если план с ним расходится, и тогда спроси пользователя."
else
  prompt="Прочти тикет $url. Составь план выполнения задачи. Работай вместе с codex."
fi

# `claude --worktree <key>` opens an existing worktree at this path instead of creating its own,
# so creating it here lets Codex start in it first, on the branch name and base we choose.
wt=$root/.claude/worktrees/$key
if [[ -d $wt ]]; then
  echo "reusing existing worktree $wt" >&2
elif git show-ref --verify --quiet "refs/heads/$key"; then
  echo "branch $key already exists; checking it out as is" >&2
  git worktree add --quiet "$wt" "$key"
else
  # Claude's own --worktree fetches at most once a day; a task branch starts from origin as it is now.
  git fetch --quiet origin "$default"
  git worktree add --quiet --no-track -b "$key" "$wt" "origin/$default"
  # Same contract as Claude's: copy gitignored files that match .worktreeinclude, such as .env.
  if [[ -f .worktreeinclude ]]; then
    git ls-files --others --ignored --exclude-from=.worktreeinclude -z |
      while IFS= read -r -d '' f; do
        git check-ignore -q -- "$f" || continue
        mkdir -p "$wt/$(dirname "$f")"
        cp -p "$f" "$wt/$f"
      done
  fi
fi

# Interactive `claude --worktree` exits at once in a repository whose trust dialog was never accepted.
"$HOME/.claude/trust-repos.sh" "$root" | sed 's/^/marked as trusted in Claude Code: /' >&2
# Codex would stop at its own trust prompt, which nothing in this flow answers.
"$HOME/.codex/trust-repos.sh" "$root" | sed 's/^/marked as trusted in Codex: /' >&2

ctl() { agtermctl "$@" --socket "$AGTERM_SOCKET"; }
node() { ctl tree --json --window "$AGTERM_WINDOW_ID" | jq -c --arg id "$sid" '[.. | objects | select(.id? == $id)][0]'; }
wait_for() {
  local expr=$1 what=$2
  for _ in $(seq 60); do
    node | jq -e "$expr" >/dev/null && return
    sleep 0.5
  done
  echo "timed out after 30s waiting for $what in session $sid" >&2
  exit 1
}

# With a plan, the new session is a companion of the planning session, so the two sit together in
# the tree; closing the parent closes it too. --no-select keeps the user's keystrokes out of the new
# panes while we type the launch lines.
if [[ -n $plan ]]; then
  place=(--parent "$AGTERM_SESSION_ID")
else
  place=(--after "$AGTERM_SESSION_ID")
fi
sid=$(ctl session new "${place[@]}" --cwd "$wt" --name "$key: $summary" --no-select)
wait_for '.realized' "the shell"

ctl session split on --axis vertical --target "$sid" >/dev/null
# Typed into an interactive shell rather than passed as --command: `codex` is a zsh function that
# hands AGTERM_SESSION_ID to Codex for peer-chat, and only an interactive shell defines it.
ctl session type --target "$sid" --pane right --stdin <<<"cd '$wt' && codex" >/dev/null
wait_for '(.splitForeground // [])[0] == "codex"' "codex in the right pane"

# Claude starts only after Codex is up, because the prompt sends it straight to peer-chat. It runs
# from the main checkout: --worktree resolves <key> against the repository it is started in.
ctl session type --target "$sid" --pane left --stdin <<<"cd '$root' && claude --worktree '$key' '$prompt'" >/dev/null
wait_for '(.foreground // [])[0] == "claude"' "claude in the left pane"
# `claude --worktree` exits at once on errors such as an untrusted folder.
sleep 3
node | jq -e '(.foreground // [])[0] == "claude"' >/dev/null || {
  echo "claude exited right after start in session $sid; read its left pane" >&2
  exit 1
}

ctl session select --target "$sid" >/dev/null
echo "$sid $wt"
