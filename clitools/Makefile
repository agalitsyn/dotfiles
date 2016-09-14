.PHONY:all
all: bins pip npm

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
