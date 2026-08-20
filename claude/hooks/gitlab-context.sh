#!/usr/bin/env bash
# SessionStart hook: when the session's repo lives on GitLab — gitlab.com or a
# self-hosted instance — state what glab is allowed to do here.
# Silent no-op outside git repos and on non-GitLab remotes.

set -uo pipefail

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

remote=$(git remote get-url origin 2>/dev/null) || \
  remote=$(git remote get-url "$(git remote 2>/dev/null | head -1)" 2>/dev/null) || remote=""

# git@host:group/repo.git, https://host/group/repo.git, ssh://git@host:2222/... -> host
host=$(printf '%s' "$remote" | sed -E 's#^[a-zA-Z0-9+.-]+://##; s#^[^/@]*@##; s#[:/].*$##')

# glab records every instance you have logged into. Host keys are the only
# entries under `hosts:` that contain a dot; sub-keys (token, user, subfolder)
# never do.
glab_config="${XDG_CONFIG_HOME:-$HOME/.config}/glab-cli/config.yml"
[ -f "$glab_config" ] || glab_config="$HOME/Library/Application Support/glab-cli/config.yml"
known=$(awk '
  /^hosts:/            { inhosts = 1; next }
  inhosts && /^[^[:space:]]/ { inhosts = 0 }
  inhosts && /^[[:space:]]+[A-Za-z0-9][A-Za-z0-9.-]*\.[A-Za-z0-9.-]+:[[:space:]]*$/ {
    gsub(/[[:space:]:]/, ""); print
  }
' "$glab_config" 2>/dev/null)

configured=false
if [ -n "$host" ] && printf '%s\n' "$known" | grep -qxF "$host"; then
  configured=true
fi

if [ "$configured" = true ]; then
  :
elif [ -n "$host" ] && [ "$host" != "${host#*gitlab}" ]; then
  :
elif [ -f "$root/.gitlab-ci.yml" ] || [ -d "$root/.gitlab" ]; then
  [ -n "$host" ] || host="(unknown host)"
else
  exit 0
fi

if ! command -v glab >/dev/null 2>&1; then
  auth_line="\`glab\` is NOT installed here. Use the GitLab web UI or the MR URL that \`git push\` prints; do not fall back to \`gh\`."
elif [ "$configured" = true ]; then
  auth_line="\`glab\` is installed and already authenticated for $host — run it directly, no login step needed."
else
  auth_line="\`glab\` is installed but $host is not in its config. Check \`glab auth status\` before assuming commands will work."
fi

skill_line=""
skills=$(compgen -G "$HOME/.claude/plugins/marketplaces/*/skills/mr-*" 2>/dev/null \
  | xargs -n1 basename 2>/dev/null | sort -u | sed 's/^/\//' | paste -sd, - | sed 's/,/, /g')
if [ -n "$skills" ]; then
  skill_line="

Prefer these installed skills over hand-rolled glab calls: $skills."
fi

context="This repository's remote is GitLab ($host), not GitHub. Use the \`glab\` CLI for forge work — \`gh\` does not work here.

$auth_line

You are allowed to do this without checking first:
- Open a merge request — \`glab mr create\`
- Amend one — \`glab mr update\` (title, description, draft/ready, labels)
- Read anything — \`glab mr view\` / \`glab mr list\` (add \`-F json --jq\` for parseable output), \`glab repo view\`, \`glab ci status\`, \`glab auth status\`, and GET calls via \`glab api\`
- Comment freely — add with \`glab mr note\`, or via \`glab api\`:
    POST   projects/:id/merge_requests/:iid/notes                     (new note)
    POST   projects/:id/merge_requests/:iid/discussions               (new thread)
    POST   projects/:id/merge_requests/:iid/discussions/:did/notes    (reply in thread)
    PUT    projects/:id/merge_requests/:iid/notes/:note_id            (edit a comment)
    DELETE projects/:id/merge_requests/:iid/notes/:note_id            (remove a comment)

Two things are off-limits and enforced by hooks, so attempting them just fails:
- Landing a merge request. Not \`glab mr merge\`, not \`gh pr merge\`, not PUT on
  .../merge_requests/:iid/merge. When an MR is ready, say so and let the user merge it.
- Any commit, push, merge, rebase, cherry-pick or revert that lands on main, master, or
  origin's default branch. Branch first, then open an MR.

Anything else — closing or reopening MRs, editing labels or milestones outside \`mr update\`,
\`glab ci retry\`, project or member changes — is not covered above: ask the user before running it.

Conventions: it is a *merge request*, never a pull request; JSON is \`-F json\`, not \`--json\`;
MRs are addressed by \`iid\`; comments are notes and discussions; MR templates live in
\`.gitlab/merge_request_templates/\`.$skill_line"

jq -nc --arg ctx "$context" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'

exit 0
