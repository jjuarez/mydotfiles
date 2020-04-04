[[ -z "${BREW_HOME}" ]] && {
  export BREW_HOME=/usr/local
  export PATH=${BREW_HOME}/sbin:${PATH}
}
