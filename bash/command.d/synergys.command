##
# Synergy Server basic CTL
#
synergy_server() {

  local SYNERGY_SERVER=/usr/local/bin/synergys
  local CONFIG=${HOME}/config/mydotfiles/synergy/synergy.conf

  case ${1} in

    start|restart)
      /usr/bin/killall synergys &>/dev/null
      ${SYNERGY_SERVER} --debug ERROR --daemon --name pc8341 --config ${CONFIG}
      ;;

    debug)
      ${SYNERGY_SERVER} --debug DEBUG --no-daemon --name pc8341 --config ${CONFIG}
      ;;

    stop)
      /usr/bin/killall synergys &>/dev/null
      ;;
  esac
}
