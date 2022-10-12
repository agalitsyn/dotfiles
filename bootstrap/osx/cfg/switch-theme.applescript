tell application "System Events"
	tell appearance preferences
		set dark mode to not dark mode
		set var to dark mode
		log var
	end tell
end tell
