# Docker clean exited images
docker::containers::clean() {
  docker container rm $(docker container ls -q --filter status=exited)
}

docker::images::clean() {
  docker image rm $(docker image ls|grep none|awk '{ print $1 }')
}

# alias
alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
