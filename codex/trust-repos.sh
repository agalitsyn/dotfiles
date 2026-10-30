#!/usr/bin/env bash
# Mark every git repository under the given directories as trusted in Codex, the same entry its
# trust prompt writes: [projects."<root>"] trust_level = "trusted" in ~/.codex/config.toml.
#
# Codex keys trust on a repository's root, so a trusted parent folder does not cover the clones
# inside it; hence the recursive walk. Already trusted roots are left alone, and the file is
# written only when something changes. Prints each root it marked.
#
#   trust-repos.sh ~/src/work
set -euo pipefail

(($#)) || { echo "usage: trust-repos.sh <dir>..." >&2; exit 2; }
cfg=${CODEX_HOME:-$HOME/.codex}/config.toml
[[ -f $cfg ]] || { echo "no $cfg" >&2; exit 2; }

repo_root() {
  local common
  common=$(git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 1
  # A worktree is trusted through its main checkout, as Codex resolves it.
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
((${#found[@]})) || exit 0

# If the config is a symlink, write the file it points to, not over the link.
python3 - "$cfg" "${found[@]}" <<'PY'
import json, os, sys, tempfile, tomllib

cfg = os.path.realpath(sys.argv[1])
with open(cfg, "rb") as f:
    raw = f.read()
projects = tomllib.loads(raw.decode()).get("projects", {})
roots = sorted({r for r in sys.argv[2:] if projects.get(r, {}).get("trust_level") != "trusted"})
if not roots:
    sys.exit(0)

lines = raw.decode().splitlines(keepends=True)
if lines and not lines[-1].endswith("\n"):
    lines[-1] += "\n"
# New tables go above the comments that close the file (an agterm marker), as Codex places them.
end = len(lines)
while end and (not lines[end - 1].strip() or lines[end - 1].lstrip().startswith("#")):
    end -= 1
added = []
for r in roots:
    if r in projects:
        # Declining the prompt writes "untrusted"; that was a decision, so it is not overridden.
        print(f"has another trust level, left as is: {r}", file=sys.stderr)
        continue
    added += ["\n", f"[projects.{json.dumps(r)}]\n", 'trust_level = "trusted"\n']
    print(r)
if not added:
    sys.exit(0)
text = "".join(lines[:end] + added + lines[end:])
tomllib.loads(text)

fd, tmp = tempfile.mkstemp(dir=os.path.dirname(cfg), prefix=".config.toml.")
try:
    with os.fdopen(fd, "w") as f:
        f.write(text)
    # Keep the config's own mode: mkstemp makes 0600, and a fixed value could widen a private file.
    os.chmod(tmp, os.stat(cfg).st_mode & 0o7777)
    os.replace(tmp, cfg)
except BaseException:
    os.unlink(tmp)
    raise
PY
