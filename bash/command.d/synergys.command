##
# Synergy Server basic CTL
#
synergy_server() {

  local SYNERGY_SERVER=/usr/local/bin/synergys
  local CONFIG=${HOME}/config/mydotfiles/synergy/synergy.conf

  case ${1} in

    start|restart)
      /usr/bin/killall ${SYNERGY_SERVER} &>/dev/null
      ${SYNERGY_SERVER} --name pc8341 --config ${CONFIG}
      ;;

    debug)
      ${SYNERGY_SERVER} --debug DEBUG2 --no-daemon --name pc8341 --config ${CONFIG}
      ;;

    stop)
      /usr/bin/killall ${SYNERGY_SERVER} &>/dev/null
      ;;
  esac
}
