#set -u -o pipefail
#set -x

# Docker clean exited images
docker::containers::clean() {
  local -r docker_exited_containers=$(docker container ls -q --filter status=exited)

  [[ -n "${docker_exited_containers}" ]] && echo "${docker_exited_containers}"|xargs docker container rm
}

docker::images::clean() {
  docker image rm $(docker image ls|grep 'none'|awk '{ print $3 }')
}

autoload docker::containers::clean
autoload docker::images::clean

alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
