URL=$(youtube-dl -f best --get-url 'https://www.youtube.com/watch?v=jfKfPfyJRdk')
ffplay -autoexit -hide_banner -loglevel error -nodisp -volume 100 "${URL}"
