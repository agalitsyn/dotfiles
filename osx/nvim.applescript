// https://gregrs-uk.github.io/2018-11-01/open-files-neovim-iterm2-macos-finder/
on run {input, parameters}

	# seem to need the full path at least in some cases
	# -p opens files in separate tabs
	set nvimCommand to "/opt/homebrew/bin/nvim -p "

	set filepaths to ""
	if input is not {} then
		repeat with currentFile in input
			set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
		end repeat
	end if

	if application "iTerm" is running then
		tell application "iTerm"
			create window with profile "Dark" command nvimCommand & filepaths
		end tell
	else
		tell application "iTerm"
			tell current session of current window
				write text nvimCommand & filepaths
			end tell
		end tell
	end if

end run
