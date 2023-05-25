set -o pipefail
#set -x


docker::container::clean() {
  docker container ps -a --filter status=exited --format {{.ID}} | xargs docker container rm -f
}

docker::image::clean() {
  docker image ls | grep none   | awk '{ print $3 }' | xargs docker image rm -f
  docker image ls | grep icr.io | awk '{ print $3 }' | xargs docker image rm -f
}

docker::image::update::nodejs() {
  for image in $(docker image ls | grep -E 'node[[:space:]]*[[:digit:]]{2}-(alpine|bullseye)' | awk '{ print $1":"$2 }'); do
    docker image pull ${image}
  done
}

docker::image::update::python() {
  for image in $(docker image ls | grep -E 'python[[:space:]]*[[:digit:]]\.[[:digit:]]{1,2}-(alpine|bullseye)' | awk '{ print $1":"$2 }'); do
    docker image pull ${image}
  done
}

docker::image::update() {
  docker::image::update::nodejs
  docker::image::update::python
  docker::image::update::tools
}


# autoloads
autoload docker::image::clean
autoload docker::image::update
autoload docker::container::clean

# aliases
alias dkic='docker::image::clean'
alias dkiu='docker::image::update'
alias dkcc='docker::container::clean'
