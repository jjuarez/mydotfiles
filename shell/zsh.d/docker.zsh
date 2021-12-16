#set -u -o pipefail
#set -x
declare NODE_DOCKER_IMAGES=(
  14.18.2-alpine3.14
  16.13.1-alpine3.14
  17.2.0-alpine3.14
)
declare ARTIFACTORY_DOCKER_REGISTRY="res-quantum-ci-docker-virtual.artifactory.swg-devops.com"
declare ARTIFACTORY_DOCKER_IMAGES=(
  postgres:11-alpine
  postgres:12.8-alpine3.14
  postgres:12.9-alpine3.14
  mongo:4.4.6
  nats:2.1.9-alpine
  nats:2.5.0-alpine3.14
  nats:2.6.6-alpine3.14
  minio/minio:RELEASE.2021-02-14T04-01-33Z
  minio/minio:RELEASE.2021-11-24T23-19-33Z
  redis:6.0.8-alpine
  redis:6.0.15-alpine3.14
  redis:6.0.16-alpine3.14
  segment/mock:v0.0.2
  busybox:latest
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
    docker image pull "node:${ni}" 2>/dev/null
  done
}

docker::images::artifactory_clean() {
  for di in "${ARTIFACTORY_DOCKER_IMAGES[@]}"; do
    docker image rm -f ${ARTIFACTORY_DOCKER_REGISTRY}/${di} 2>/dev/null
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
