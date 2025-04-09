brew install git ripgrep coreutils fd

brew tap d12frosted/emacs-plus
brew install emacs-plus --with-native-comp --with-modern-icon

# Link app
osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@29/Emacs.app" at POSIX file "/Applications" with properties {name:"Emacs.app"}'

# Daemon
brew services start d12frosted/emacs-plus/emacs-plus@29

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

echo 'export PATH="~/.config/emacs/bin:$PATH"' > ~/.zsh.d/emacs.zsh

