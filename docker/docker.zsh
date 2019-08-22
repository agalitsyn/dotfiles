docker-enter() {
	local container_id=${1}
    docker exec -it "$container_id" bash
}

docker-logs() {
	local container_id=${1}
    docker logs -f "$container_id"
}

docker-stop-delete() {
	local container_id=${1}
    docker stop "$container_id" && docker rm "$container_id"
}

docker-cleanup-images() {
	docker rmi -f $(docker images -f "dangling=true" -q)
}

docker-cleanup-containers() {
    docker rm $(docker ps --all -q -f status=exited)
}

docker-enter-osx-vm() {
	screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
}
