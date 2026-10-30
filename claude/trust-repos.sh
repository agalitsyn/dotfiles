#!/usr/bin/env bash
# Mark every git repository under the given directories as trusted in Claude Code, the documented
# manual equivalent of accepting the workspace trust dialog:
# projects["<root>"].hasTrustDialogAccepted = true in ~/.claude.json.
#
# Trust is keyed on a repository's root and does not reach a repository nested in a trusted
# folder, so a trusted ~/src still prompts for every clone inside it; hence the recursive walk.
# Already trusted roots are left alone, and the file is written only when something changes.
# Prints each root it marked.
#
#   trust-repos.sh ~/src/work
set -euo pipefail

(($#)) || { echo "usage: trust-repos.sh <dir>..." >&2; exit 2; }
cfg=$HOME/.claude.json
[[ -f $cfg ]] || { echo "no $cfg" >&2; exit 2; }

repo_root() {
  local common
  common=$(git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 1
  # Trust is keyed on the main checkout's root, also for a worktree or a path inside one.
  (cd "$(dirname "$common")" && pwd -P)
}

found=()
for dir in "$@"; do
  [[ -d $dir ]] || { echo "not a directory: $dir" >&2; exit 2; }
  # A directory inside a repository counts as that repository.
  if root=$(repo_root "$dir"); then found+=("$root"); fi
  while IFS= read -r -d '' git; do
    if root=$(repo_root "$(dirname "$git")"); then
      found+=("$root")
    else
      echo "skipping, not a usable repository: $(dirname "$git")" >&2
    fi
  done < <(find "$dir" \( -name node_modules -o -name .claude \) -prune -o -name .git -print0 -prune)
done

roots=()
while IFS= read -r root; do
  [[ -n $root ]] || continue
  jq -e --arg p "$root" '.projects[$p].hasTrustDialogAccepted == true' "$cfg" >/dev/null || roots+=("$root")
done < <(printf '%s\n' "${found[@]}" | sort -u)
((${#roots[@]})) || exit 0

tmp=$(mktemp "$cfg.XXXXXX")
trap 'rm -f "$tmp"' EXIT
jq '.projects as $p | reduce $ARGS.positional[] as $r (.; .projects[$r] = (($p[$r] // {}) + {hasTrustDialogAccepted: true}))' \
  --args "${roots[@]}" <"$cfg" >"$tmp"
# Keep the config's own mode: mktemp makes 0600, and a fixed value could widen a private file.
chmod "$(stat -c %a "$cfg" 2>/dev/null || stat -f %Lp "$cfg")" "$tmp"
mv "$tmp" "$cfg"
printf '%s\n' "${roots[@]}"
