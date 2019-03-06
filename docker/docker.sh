docker-enter() {
	local container_id=${1}
    docker exec -it "$container_id" bash
}
alias de="docker-enter"

docker-logs() {
	local container_id=${1}
    docker logs -f "$container_id"
}
alias dl="docker-logs"

docker-stop-delete() {
	local container_id=${1}
    docker stop "$container_id" && docker rm "$container_id"
}
alias dsd="docker-stop-delete"

docker-cleanup-images() {
	docker rmi -f $(docker images -f "dangling=true" -q)
}
alias dci="docker-cleanup-images"

docker-cleanup-containers() {
    docker rm $(docker ps --all -q -f status=exited)
}
alias dcc="docker-cleanup-containers"

docker-enter-osx-vm() {
	screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
}
alias dvm="docker-enter-osx-vm"
