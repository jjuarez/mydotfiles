#echo "File: ${0}"

# Docker clean exited images
docker::containers::clean() {
  docker container rm $(docker container ls -q --filter status=exited)
}

docker::containers::connect() {
  if docker container ls >/dev/null 2>&1; then
    local container=$(docker container ls|awk '{ if (NR!=1) print $1 ": " $(NF) }'|fzf --height 40%)

    if [ -n "${container}" ]; then
      container_id=$(echo ${container}|awk -F ': ' '{ print $1 }')
      docker container exec -it ${container_id} /bin/bash || docker container exec -it ${container_id} /bin/sh
    else
      echo "No Docker container selected"
      return 1
    fi
  else
    echo "Your Docker daemon is not running!"
    return 2
  fi
}

docker::images::clean() {
  docker image rm $(docker image ls|grep none|awk '{ print $1 }')
}

# alias
alias dcc='docker::containers::clean'
alias dic='docker::images::clean'
