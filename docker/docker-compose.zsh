docker-compose-stop-delete() {
    local container_id=${1}
    docker-compose rm --stop --force "$container_id"
}

docker-compose-logs() {
    local container_id=${1}
    docker-compose logs -f --tail=100 "$container_id"
}
