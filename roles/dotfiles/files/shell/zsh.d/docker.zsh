#set -u -o pipefail
#set -x

# Docker clean exited images
docker::containers::clean() {
  local -r docker_exited_containers=$(docker container list --filter "status=exited" -q)

  [[ -n "${docker_exited_containers}" ]] && echo "${docker_exited_containers}"|xargs docker container rm
}

docker::images::clean() {
  local -r docker_dangling_images=$(docker image list --filter "dangling=true" -q)

  [[ -n "${docker_dangling_images}" ]] && docker image rm $(docker image list --filter "dangling=true" -q)
}

# autoloads
autoload docker::containers::clean
autoload docker::images::clean

# aliases
alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
