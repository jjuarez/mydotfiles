[[ -z "${BREW_HOME}" ]] && {

  BREW_HOME=/usr/local
  PATH=${BREW_HOME}/sbin:${PATH}

  export BREW_HOME PATH
}
