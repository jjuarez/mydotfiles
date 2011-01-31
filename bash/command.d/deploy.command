BUILD_SERVER=builds
REMOTE_PATH=~/jboss/server/default

move2server() {

  [ -z "${1}" -o -z "${2}" ] && exit 1

  /usr/bin/scp -C2q ${BUILD_SERVER}:${1} /tmp/${1} && 
  /usr/bin/scp -C2q /tmp/${1} ${2}:${REMOTE_PATH} &&
  ssh ${BUILD_SERVER} "rm -f ${1}" && 
  rm -f /tmp/${1}
}
