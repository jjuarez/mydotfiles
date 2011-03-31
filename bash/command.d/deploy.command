BUILD_SERVER=${BUILD_SERVER:-"builds"}


__clean_artifacts() {
  
  echo "Cleaning artifacts..."
  /usr/bin/ssh -Cq ${BUILD_SERVER} "rm -f ${1} 2>/dev/null" && 
  [ -s "/tmp/${1}" ] && rm -f /tmp/${1}
}


move2server() {

  [ -z "${1}" -o -z "${2}" ] && exit 1

  /usr/bin/scp -Cq ${BUILD_SERVER}:${1} /tmp/${1} && 
  /usr/bin/scp -Cq /tmp/${1} ${2}: &&

  __clean_artifacts ${1}
}
