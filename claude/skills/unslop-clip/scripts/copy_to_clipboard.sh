#!/bin/bash
# Put a file on the macOS clipboard, then its text content, in that order.
# Two writes on purpose: a clipboard-history manager records both entries, so
# the user can paste either the file (attachment) or the text. Final clipboard
# state is the text, so a plain Cmd+V pastes text.
set -euo pipefail

if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "usage: $0 <file>" >&2
  exit 1
fi
file="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"

osascript - "$file" >/dev/null <<'EOF'
on run argv
  set the clipboard to POSIX file (item 1 of argv)
end run
EOF

sleep 0.4  # let clipboard managers record the file entry before it's replaced

pbcopy < "$file"
echo "clipboard: text of $file (file entry one step back in history)"
