#!/usr/bin/env bash

set -xe 

# UI
apm install \
	seti-ui \
	monokai-seti \
	atom-material-ui \
	atom-material-syntax

# Editor features
apm install \
	open-recent \
	highlight-selected \
	minimap \
	minimap-highlight-selected \
	last-cursor-position \
	open-recent \
	open-in-browser \
	autocomplete-paths \
	git-plus \
	merge-conflicts \
	file-icons \
	auto-detect-indentation \
	remote-edit \
	editorconfig \
	atom-beautify \
	linter \
	todo-show \
	change-case \
	atom-alignment \
	highlight-line

# FE
apm install \
	linter-htmlhint \
	linter-csslint \
	linter-jslint \
	linter-jshint \
	linter-eslint \
	autoclose-html \
	emmet \
	language-babel \
	language-jade \
	linter-jade \
	jade-beautify \
	pigments \
	react \
	es6-javascript \
	react-snippets \
	atom-ternjs \
	atom-typescript

# BE
apm install \
	language-docker \
	go-rename \
	go-plus \
	language-restructuredtext \
	linter-flake8 \
	python-tools \
	autocomplete-python
