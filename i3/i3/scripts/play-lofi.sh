# for graphical approach see https://github.com/raphtlw/dotfiles/blob/master/bin/ytplay

URL=$(youtube-dl -f best --get-url 'https://www.youtube.com/watch?v=jfKfPfyJRdk')
ffplay -autoexit -hide_banner -loglevel error -nodisp -volume 100 "${URL}"
