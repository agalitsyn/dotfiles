#!/bin/bash
# vim: tabstop=4 shiftwidth=4 noexpandtab
#
# Clean up local branches whose upstream is gone (deleted on the remote),
# including any worktrees associated with them.
#
# Usage:
#   ./clean-gone.sh         # interactive: lists branches, asks to confirm
#   ./clean-gone.sh -y      # non-interactive: deletes without confirmation
#
# Relies on `fetch.prune = true` (or a prior `git fetch --prune`) so that
# stale remote-tracking refs are gone and branches show as [gone].

set -euo pipefail

ASSUME_YES=0
if [ "${1:-}" = "-y" ] || [ "${1:-}" = "--yes" ]; then
    ASSUME_YES=1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not a git repository." >&2
    exit 1
fi

# Collect [gone] branches (strip leading +/*/whitespace).
GONE_BRANCHES=$(git branch -v | grep '\[gone\]' | sed 's/^[+* ]*//' | awk '{print $1}' || true)

if [ -z "$GONE_BRANCHES" ]; then
    echo -e "\033[32mNo [gone] branches. Nothing to do.\033[0m"
    exit 0
fi

echo -e "\n\033[1mBranches with gone upstream:\033[0m"
echo "$GONE_BRANCHES" | sed 's/^/  /'

if [ "$ASSUME_YES" -ne 1 ]; then
    echo ""
    read -r -p "Delete these branches (and any associated worktrees)? [y/N] " reply
    case "$reply" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Aborted."; exit 0 ;;
    esac
fi

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "$GONE_BRANCHES" | while read -r branch; do
    [ -z "$branch" ] && continue
    echo -e "\n\033[33mProcessing: $branch\033[0m"

    worktree=$(git worktree list --porcelain \
        | awk -v b="refs/heads/$branch" '
            /^worktree / { wt=$2 }
            $1=="branch" && $2==b { print wt; exit }
        ')

    if [ -n "$worktree" ] && [ "$worktree" != "$REPO_ROOT" ]; then
        echo "  removing worktree: $worktree"
        git worktree remove --force "$worktree"
    fi

    echo "  deleting branch: $branch"
    git branch -D "$branch"
done

echo -e "\n\033[32mDone.\033[0m"
