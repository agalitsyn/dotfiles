#!/usr/bin/env bash
# Open a Jira ticket as a new agterm session, a companion of the caller's: a git worktree on a fresh
# default branch, Codex in the right pane of a vertical split, then Claude in the left pane with
# the planning prompt. Prints the new session id and the worktree path.
set -euo pipefail

usage='usage: open-task.sh <jira-url> [--repo DIR] [--plan FILE] [--scope TEXT] [--name SUFFIX]'
url='' repo=$PWD plan='' scope='' suffix=''
while (($#)); do
  case $1 in
    --name) suffix=${2:?$usage}; shift 2 ;;
    --name=*) suffix=${1#*=}; shift ;;
    --repo) repo=${2:?$usage}; shift 2 ;;
    --repo=*) repo=${1#*=}; shift ;;
    --plan) plan=${2:?$usage}; shift 2 ;;
    --plan=*) plan=${1#*=}; shift ;;
    --scope) scope=${2:?$usage}; shift 2 ;;
    --scope=*) scope=${1#*=}; shift ;;
    -*) echo "$usage" >&2; exit 2 ;;
    *) [[ -z $url ]] || { echo "$usage" >&2; exit 2; }; url=$1; shift ;;
  esac
done
[[ -n $url ]] || { echo "$usage" >&2; exit 2; }
# The URL ends up inside a single-quoted shell line typed into the pane.
[[ $url =~ ^https?://[A-Za-z0-9./:_?=\&%#-]+$ ]] || { echo "not a plain Jira URL: $url" >&2; exit 2; }
key=$(grep -oE '[A-Z][A-Z0-9]+-[0-9]+' <<<"$url" | head -1 || true)
[[ -n $key ]] || { echo "no ticket key in: $url" >&2; exit 2; }
# One ticket, several sessions in the same repository: each gets its own worktree, branch and plan
# file named <key>-<suffix>. The name ends up in paths, a branch and a single-quoted shell line.
[[ -z $suffix || $suffix =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "--name wants [a-z0-9-]: $suffix" >&2; exit 2; }
name=$key${suffix:+-$suffix}
[[ ${AGTERM_ENABLED:-} == 1 && -n ${AGTERM_SOCKET:-} ]] || { echo "not inside agterm" >&2; exit 2; }
[[ -z $plan || -s $plan ]] || { echo "plan file missing or empty: $plan" >&2; exit 2; }
[[ -d $repo ]] || { echo "not a directory: $repo" >&2; exit 2; }
# The scope is typed into the pane as one line; a newline would submit it halfway.
scope=${scope//$'\n'/ }

ctl() { agtermctl "$@" --socket "$AGTERM_SOCKET"; }

# The quick terminal belongs to no session and no window, so neither variable is set there: the new
# session goes into the active window, after the session selected in it.
if [[ -z ${AGTERM_WINDOW_ID:-} ]]; then
  AGTERM_WINDOW_ID=$(ctl window list | awk '/\[active\]/ { print $1; exit }')
  [[ -n $AGTERM_WINDOW_ID ]] || { echo "cannot find agterm's active window" >&2; exit 2; }
fi
caller=${AGTERM_SESSION_ID:-}
anchor=$caller
if [[ -z $anchor ]]; then
  anchor=$(ctl tree --json --window "$AGTERM_WINDOW_ID" |
    jq -r 'first(.result.tree.workspaces[] | select(.active) | .. | objects | select(has("surfaces") and .active == true) | .id) // empty')
  [[ -n $anchor ]] || { echo "no selected session in agterm's active window to place the new one after" >&2; exit 2; }
fi

common=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
  echo "not a git repository: $repo" >&2
  exit 2
}
# The main checkout, even when called from inside another worktree.
root=$(dirname "$common")
# The worktree directory is named after the key, so the new Claude would take that for the repository.
repo_name=$(basename "$root")

# A plan made in the calling session goes to a stable place: that session's scratchpad dies with it.
# Named per repository, because one ticket can be split into sessions of several repositories.
if [[ -n $plan ]]; then
  plan_dst=$HOME/.claude/plans/$name-$repo_name.md
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
# A ticket that spans several repositories gets one session per repository; without this line each
# of them would research and plan the whole ticket.
part="Эта сессия отвечает только за изменения в репозитории $repo_name. Если тикет затрагивает и другие репозитории, их часть делается отдельно, в своих worktree и сессиях: их код смотри только там, где он стыкуется с твоей частью (контракт, порядок выкатки), и не исследуй, не планируй и не меняй его."
[[ -z $scope ]] || part+=" Твоя часть тикета: $scope"
# What the user sees first in the new session, before planning or peer-chat starts.
recap="дай пользователю короткий recap на языке этой сессии: номер тикета кликабельной markdown-ссылкой [$key]($url) и название «$summary»; репозиторий $repo_name; в двух-трёх предложениях, что мы должны сделать в этой задаче в этом репозитории"
if [[ -n $plan ]]; then
  prompt="План по тикету $url уже составлен и согласован с пользователем и Codex: $plan_dst. $part Прочти план, затем $recap. После этого выполняй план вместе с codex. Заново тикет не планируй; открывай его, только если план с ним расходится, и тогда спроси пользователя."
else
  prompt="Прочти тикет $url. $part Затем $recap. После этого составь план выполнения своей части задачи. Работай вместе с codex."
fi
# The prompt is typed inside single quotes; the summary and the repository name may carry one.
prompt=${prompt//\'/\'\\\'\'}

# `claude --worktree <key>` opens an existing worktree at this path instead of creating its own,
# so creating it here lets Codex start in it first, on the branch name and base we choose.
wt=$root/.claude/worktrees/$name
if [[ -d $wt ]]; then
  echo "reusing existing worktree $wt" >&2
elif git show-ref --verify --quiet "refs/heads/$name"; then
  echo "branch $name already exists; checking it out as is" >&2
  git worktree add --quiet "$wt" "$name"
else
  # Claude's own --worktree fetches at most once a day; a task branch starts from origin as it is now.
  git fetch --quiet origin "$default"
  git worktree add --quiet --no-track -b "$name" "$wt" "origin/$default"
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

# The new session is a companion of the calling one: the caller stays the main session and every
# ticket it starts sits under it in the tree; closing the parent closes them too. A companion caller
# means its parent, so they stay siblings under one main session. --no-select keeps the user's
# keystrokes out of the new panes while we type the launch lines.
if [[ -n $caller ]]; then
  place=(--parent "$caller")
else
  echo "no calling session (quick terminal): opening after $anchor, not as a companion" >&2
  place=(--after "$anchor")
fi
sid=$(ctl session new "${place[@]}" --cwd "$wt" --name "$key${suffix:+ $suffix} [$repo_name]: $summary" --no-select)
wait_for '.realized' "the shell"

# The tree can report the session realized a moment before split accepts it ("session not
# realized"), seen when several sessions are opened back to back. Retry for a few seconds.
for i in $(seq 10); do
  ctl session split on --axis vertical --target "$sid" >/dev/null 2>&1 && break
  [[ $i -lt 10 ]] || { echo "cannot split session $sid" >&2; exit 1; }
  sleep 0.5
done
# Typed into an interactive shell rather than passed as --command: `codex` is a zsh function that
# hands AGTERM_SESSION_ID to Codex for peer-chat, and only an interactive shell defines it.
ctl session type --target "$sid" --pane right --stdin <<<"cd '$wt' && codex -a never -s workspace-write -c sandbox_workspace_write.network_access=true -c check_for_update_on_startup=false" >/dev/null
wait_for '(.splitForeground // [])[0] == "codex"' "codex in the right pane"

# Claude starts only after Codex is up, because the prompt sends it straight to peer-chat. It runs
# from the main checkout: --worktree resolves <key> against the repository it is started in.
ctl session type --target "$sid" --pane left --stdin <<<"cd '$root' && claude --worktree '$name' '$prompt'" >/dev/null
wait_for '(.foreground // [])[0] == "claude"' "claude in the left pane"
# `claude --worktree` exits at once on errors such as an untrusted folder.
sleep 3
node | jq -e '(.foreground // [])[0] == "claude"' >/dev/null || {
  echo "claude exited right after start in session $sid; read its left pane" >&2
  exit 1
}

ctl session select --target "$sid" >/dev/null
echo "$sid $wt"
