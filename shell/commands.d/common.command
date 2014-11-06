##
# Make a dir and change to it
#
mcd( ) { 

  [ -n "${@}" ] || exit 1 

  mkdir -p "${@}" && cd "${@}"; 
}
