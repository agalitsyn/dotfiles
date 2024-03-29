#!/bin/bash
# vim: tabstop=4 shiftwidth=4 noexpandtab

set -xe

# You can export and then parse existing bookmarks from your browser, like:
# cat bookmarks_11_23_22.html | htmlq -a href a | sort | uniq > bookmarks.txt
BOOKMARKS_FILE=${BOOKMARKS_FILE:-~/Yandex.Disk/misc/bookmarks.txt}

# Do not create it automatically, because it should exists and should not be empty
if [[ -d $BOOKMARKS_FILE ]]; then
    notify-send "File is not exists" "$BOOKMARKS_FILE"
    exit 2
fi

case "$1" in
add)
    text=$(xclip -o)
    [[ -n "$text" ]] && echo "$text" >>"$BOOKMARKS_FILE"
    notify-send "Added to bookmarks" "$text"
    ;;
search)
    xdotool type $(grep -v '^#' "$BOOKMARKS_FILE" | dmenu -i -l 50 | cut -d ' ' -f1)
    ;;
format)
    cat "$BOOKMARKS_FILE" | sort | uniq >"$BOOKMARKS_FILE"
    ;;
*)
    echo "Usage: $0 {add|search|format}"
    exit 2
    ;;
esac
