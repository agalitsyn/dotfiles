# for graphical approach see https://github.com/raphtlw/dotfiles/blob/master/bin/ytplay
set -ex

TRACK_URL=${1:-'https://www.youtube.com/watch?v=jfKfPfyJRdk'}
URL=$(yt-dlp --cookies-from-browser brave -f b --get-url "${TRACK_URL}")
ffplay -autoexit -hide_banner -loglevel error -nodisp -volume 100 "${URL}"

