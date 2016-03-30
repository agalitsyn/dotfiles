# The GOPATH environment variable specifies the location of your workspace. It is
# likely the only environment variable you'll need to set when developing Go
# code.

# To get started, create a workspace directory and set GOPATH accordingly. Your
# workspace can be located wherever you like, but we'll use $HOME/go in this
# document. Note that this must not be the sameath as your Go installation.
#
# http://golang.org/doc/code.html

alias gofmt='gofmt -tabs=false -tabwidth=4 -w'

function go-init-root() {
    cat > .goenv << EOF
export GOPATH=$(pwd)
export PATH=\$PATH:\$GOPATH/bin
export GO15VENDOREXPERIMENT=1
EOF

    source .goenv
    go env

    # Tools
    go get -u golang.org/x/tools/cmd/godoc
    go get -u golang.org/x/tools/cmd/oracle
    go get -u golang.org/x/tools/cmd/goimports
    go get -u github.com/nsf/gocode
    go get -u github.com/golang/lint/golint
    go get -u github.com/kisielk/errcheck
    go get -u github.com/rogpeppe/godef
    go get -u github.com/jstemmer/gotags
    go get -u github.com/tools/godep
    go get -u github.com/monochromegane/the_platinum_searcher
    go get -u github.com/alecthomas/gometalinter
    go get -u golang.org/x/tools/cmd/gorename
    go get -u github.com/klauspost/asmfmt/cmd/asmfm

    echo "source $(pwd)/.goenv" >> ~/.bash.d/extra
    echo "Run:"
    echo "gotags -tag-relative=true -R=true -sort=true -f="tags" -fields=+l ."
    echo "after installing packages"
}
