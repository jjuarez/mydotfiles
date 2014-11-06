##
# Tartify the parameter directory
tar-that(){

  [ -n "${1}" -a -d "${1}" ] || exit 1

  local tar="tar"
  local directory="${1}" 

  # If exist GNU tar version...    
  [ -n "${BREW_HOME}" -a -x "${BREW_HOME}/bin/gtar" ] && tar="${HOME_BREW}/bin/gtar" 

  ${tar} -czf ${directory}{.tar.gz,} 
}
