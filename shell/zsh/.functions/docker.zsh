# Docker clean exited images
docker::containers::clean() {
  docker container rm $(docker container ls -q --filter status=exited)
}

# alias
alias dcc='docker::containers::clean'
