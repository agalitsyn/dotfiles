.PHONY:all
all: bins go pip npm note

.PHONY: bins
bins:
	curl -sSL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o ~/bin/jq && chmod +x ~/bin/jq
	curl -sSL https://github.com/zyedidia/micro/releases/download/v1.0.3/micro-1.0.3-linux64.tar.gz | tar -zx && mv micro-1.0.3/micro ~/bin/ && rm -rf micro-1.0.3*

.PHONY: pip
pip:
	sudo -H pip install --upgrade \
		mkdocs \
		pygments \
		awscli \
		httpie \
		neovim

.PHONY: npm
npm:
	sudo npm install --global \
		node-static \
		json-server \
		git-open \
		git-recent \
		diff-so-fancy \
		trash-cli

.PHONY: go
go:
	go get -u github.com/shurcooL/markdownfmt
	go get -u github.com/shurcooL/git-branches

.PHONY: note
note:
	echo "There are tools, which can be in OS repo (apt ot brew), and it's easier to install them from there, because I don't have dev tools installed for compilation:"
	echo "\t * https://github.com/koalaman/shellcheck (Haskell)"
	echo "\t * https://github.com/wg/wrk (C)
