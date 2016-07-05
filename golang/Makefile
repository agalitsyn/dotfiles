PACKAGES := golang.org/x/tools/cmd/goimports \
	github.com/golang/lint/golint \
	github.com/mattn/goreman \
	github.com/tools/godep \
	github.com/kardianos/govendor \
	github.com/alecthomas/gometalinter \
	github.com/warmans/golocc \
	github.com/divan/depscheck \
	github.com/odeke-em/drive/cmd/drive \
	k8s.io/kubernetes/cmd/kubectl \
	github.com/kubernetes/minikube/cmd/minikube

packages:
	$(foreach pkg,$(PACKAGES),go get -u $(pkg);)
	gometalinter --install --update

install:
	$$(bash install.sh)
