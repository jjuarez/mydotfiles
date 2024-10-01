set -o pipefail
#set -x


docker::container::clean() {
  docker container ps -a --filter status=exited --format {{.ID}} | xargs docker container rm -f
}

docker::image::clean() {
  docker image ls | grep none   | awk '{ print $3 }' | xargs docker image rm -f
  docker image ls | grep icr.io | awk '{ print $3 }' | xargs docker image rm -f
}


# autoloads
autoload docker::image::clean
autoload docker::container::clean

# aliases
alias dkic='docker::image::clean'
alias dkiu='docker::image::update'
alias dkcc='docker::container::clean'
