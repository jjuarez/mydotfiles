mcd( ) { 

  [ -n "${@}" ] || exit 1 

  mkdir -p "${@}" && cd "${1}"; 
}

truncate( ) { 

  [ -s "${1}" ] && cat /dev/null > "${1}"
}

