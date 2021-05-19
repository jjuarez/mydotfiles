#set -u -o pipefail
#set -x
declare NODE_DOCKER_IMAGES=(
  12.22.1
  12.22.1-alpine3.13
  14.16.1
  14.16.1-alpine3.13
)
declare ARTIFACTORY_DOCKER_REGISTRY="res-quantum-ci-docker-virtual.artifactory.swg-devops.com"
declare ARTIFACTORY_DOCKER_IMAGES=(
  busybox:latest
  postgres:11-alpine
  mongo:4.4
  nats:2.1.9-alpine
  nats-streaming:0.20.0-alpine
  minio/minio:RELEASE.2021-02-14T04-01-33Z
  redis:6.0.8-alpine
  segment/mock:v0.0.2
)

# Docker clean exited images
docker::containers::clean() {
  local -r docker_exited_containers=$(docker container list --filter "status=exited" -q)

  [[ -n "${docker_exited_containers}" ]] && echo "${docker_exited_containers}"|xargs docker container rm
}

docker::images::clean() {
  docker image rm $(docker image list --filter "dangling=true" -q)
}

docker::images::update_latest() {
for di in $(docker image list --format "{{.Repository}} {{.Tag}}"|grep latest|grep -vE "(quantum-computing|quantum-tools)"|awk '{ print $1 }'); do
    echo "Pulling: ${di}..."
    docker pull ${di} -q
  done 2>/dev/null
}

docker::images::update_node() {
  for ni in "${NODE_DOCKER_IMAGES[@]}"; do
    echo "Docker image update: ${ni}..."
    docker image pull "node:${ni}"
  done
}

docker::images::artifactory_clean() {
  for di in "${ARTIFACTORY_DOCKER_IMAGES[@]}"; do
    docker image rm ${ARTIFACTORY_DOCKER_REGISTRY}/${di}
  done
}

# autoloads
autoload docker::containers::clean
autoload docker::images::clean
autoload docker::images::update_latest
autoload docker::images::update_node
autoload docker::images::artifactory_clean

# aliases
alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
alias diul='docker::images::update_latest'
alias diac='docker::images::artifactory_clean'
