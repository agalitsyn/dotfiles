function docker-enter() {
	local container_id=${1}
    docker exec -it "$container_id" bash
}
alias de="docker-enter"

function docker-logs() {
	local container_id=${1}
    docker logs -f "$container_id"
}
alias dl="docker-logs"

function docker-stop-delete() {
	local container_id=${1}
    docker stop "$container_id" && docker rm "$container_id"
}
alias dsd="docker-stop-delete"

function docker-cleanup-images() {
    docker rmi $(docker images | awk '/^<none>/ {print $3}')
}
alias dci="docker-cleanup-images"

function docker-cleanup-containers() {
    docker rm $(docker ps --all -q -f status=exited)
}
alias dcc="docker-cleanup-containers"