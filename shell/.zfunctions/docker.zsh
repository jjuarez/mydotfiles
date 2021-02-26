#set -u -o pipefail
#set -x

# Docker clean exited images
docker::containers::clean() {
  local -r docker_exited_containers=$(docker container list --filter "status=exited" -q)

  [[ -n "${docker_exited_containers}" ]] && echo "${docker_exited_containers}"|xargs docker container rm
}

docker::images::clean() {
  docker image rm $(docker image list --filter "dangling=true" -q)
}

docker::images::update_latest() {
  for di in $(docker image list --format "{{.Repository}} {{.Tag}}"|grep latest|grep -v ".icr.io"|awk '{ print $1 }'); do
    echo "Pulling: ${di}..."
    docker pull ${di} -q
  done 2>/dev/null
}

autoload docker::containers::clean
autoload docker::images::clean

alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
alias diul='docker::images::update_latest'
alias dil='docker image list'
alias dcl='docker container list'
