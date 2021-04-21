#!/bin/bash
#
# Source: https://habr.com/ru/post/449820/
#
# Find bundle id:
# > osascript -e 'id of app "Sublime Text"'
# com.sublimetext.3

# this allows us terminate the whole process from within a function
trap "exit 1" TERM
export TERM_PID=$$

# check `duti` installed
command -v duti >/dev/null 2>&1 || \
  { echo >&2 "duti required: brew install duti"; exit 1; }

get_bundle_id() {
    osascript -e "id of app \"${1}\"" || kill -s TERM $TERM_PID;
}

assoc() {
    bundle_id=$1; shift
    role=$1; shift
    while [ -n "$1" ]; do
        echo "setting file assoc: $bundle_id .$1 $role"
        duti -s "$bundle_id" ".${1}" "$role"
        shift
    done
}

TEXT_EDITOR=$(get_bundle_id "Sublime Text")
MEDIA_PLAYER=$(get_bundle_id "VLC")

assoc "$TEXT_EDITOR" "editor" txt md js jse json reg bat ps1 cfg sh bash yaml
assoc "$MEDIA_PLAYER" "viewer" mkv mp4 avi mov webm
assoc "$MEDIA_PLAYER" "viewer" flac fla ape wav mp3 wma m4a ogg ac3
