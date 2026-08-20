#!/usr/bin/env bash
# PreToolUse(Bash) guard. Two hard rules:
#   1. Nothing that creates or moves a commit on a protected branch.
#   2. No landing a merge request from the CLI.
# Emits a deny decision, or exits silently to leave the call alone.

set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

# Fast path: the overwhelming majority of Bash calls mention none of these.
printf '%s' "$cmd" | grep -Eqw 'git|glab|gh' || exit 0

deny() {
  jq -nc --arg r "$1" '{hookSpecificOutput: {
     hookEventName: "PreToolUse",
     permissionDecision: "deny",
     permissionDecisionReason: $r}}'
  exit 0
}

# main/master always, plus whatever origin actually calls its default branch
# (trunk, develop, ...) so the guard follows the repo instead of a hardcoded pair.
protected=$'main\nmaster'
default_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
[ -n "$default_branch" ] && protected+=$'\n'"$default_branch"
is_protected() { [ -n "${1:-}" ] && printf '%s\n' "$protected" | grep -qxF "$1"; }

branch_of() { git ${1:+-C "$1"} rev-parse --abbrev-ref HEAD 2>/dev/null; }

# Walk the command as an ordered sequence of segments, tracking which branch each
# one would run on: `git switch master && git commit` must be caught even though
# HEAD is still on a feature branch when the hook fires.
effective=$(branch_of)

while IFS= read -r seg; do
  seg="${seg#"${seg%%[![:space:]{(!]*}"}"
  [ -n "$seg" ] || continue
  read -ra toks <<<"$seg"
  tool="${toks[0]:-}"

  if [ "$tool" = "git" ]; then
    i=1 repodir=""
    while [[ "${toks[i]:-}" == -* ]]; do
      case "${toks[i]}" in
        -C) repodir="${toks[i+1]:-}"; i=$((i + 2)) ;;
        -c|--git-dir|--work-tree|--namespace) i=$((i + 2)) ;;
        *) i=$((i + 1)) ;;
      esac
    done
    sub="${toks[i]:-}"
    target="$effective"
    [ -n "$repodir" ] && target=$(branch_of "$repodir")

    case "$sub" in
      checkout|switch)
        for t in "${toks[@]:i+1}"; do
          case "$t" in -*) continue ;; *) effective="$t"; break ;; esac
        done
        ;;
      commit|merge|rebase|cherry-pick|revert|am)
        is_protected "$target" && deny "Blocked: \`git $sub\` would put a commit on the protected branch '$target'. Protected branches here are: $(printf '%s' "$protected" | tr '\n' ' '). Create a feature branch first (git switch -c <name>) and open a merge request instead. This guard has no per-call override — if the user genuinely wants a commit on '$target', they must run it themselves."
        ;;
      push)
        force=false refspecs=()
        for t in "${toks[@]:i+1}"; do
          case "$t" in
            --all|--mirror) deny "Blocked: \`git push $t\` would update every branch, including protected ones ($(printf '%s' "$protected" | tr '\n' ' ')). Push a single feature branch by name instead." ;;
            -f|--force|--force-with-lease*|--force-if-includes) force=true ;;
            -*) ;;
            *) refspecs+=("$t") ;;
          esac
        done
        # refspecs[0] is the remote; anything after it names refs explicitly.
        if [ "${#refspecs[@]}" -le 1 ]; then
          is_protected "$target" && deny "Blocked: a bare \`git push\` from '$target' would publish commits on that protected branch. Move the work onto a feature branch and push that instead."
        else
          for r in "${refspecs[@]:1}"; do
            dest="${r##*:}"; dest="${dest#+}"; dest="${dest#refs/heads/}"
            [ "$dest" = "HEAD" ] && dest="$target"
            is_protected "$dest" && deny "Blocked: \`git push\` targets the protected branch '$dest'$([ "$force" = true ] && printf ' (and force-updates it)'). Push a feature branch and open a merge request instead."
          done
        fi
        ;;
    esac

  elif [ "$tool" = "glab" ] || [ "$tool" = "gh" ]; then
    if printf '%s' "$seg" | grep -Eq '\b(mr|pr)[[:space:]]+merge\b'; then
      deny "Blocked: merging a merge request is never automatic here. Report that the MR is ready and let the user merge it in GitLab, or ask them to run the merge themselves."
    fi
    if printf '%s' "$seg" | grep -Eq '\bapi\b.*(merge_requests|pulls)/[^/[:space:]]+/merge\b'; then
      deny "Blocked: that is the merge-request merge endpoint. Merging is never automatic here — hand the MR back to the user to merge."
    fi
  fi
done <<<"$(printf '%s\n' "$cmd" | sed -E 's/\|\||&&|[;&|]/\n/g')"

exit 0
