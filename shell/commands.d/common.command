mcd( ) { 

  [ -n "${@}" ] || exit 1 

  mkdir -p "${@}" && cd "${1}"; 
}
