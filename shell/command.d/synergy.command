##
# Functions
#
synergy_server() {

  local synergy_daemon="/usr/local/bin/synergys"

  [ -x "${synergy_daemon}" ] && {

    case ${1} in
      dstart)
        ${synergy_daemon} --no-daemon --debug DEBUG --name `hostname -s` &>/dev/null
        ;;
      start)
        ${synergy_daemon} --daemon --restart --debug ERROR --name `hostname -s` &>/dev/null
        ;;
      stop)
        /bin/kill -15 `ps -eo pid,command|grep ${synergy_daemon} 2>/dev/null|grep -v 'grep'|awk '{print $1}'` 2>/dev/null
        ;;
      kill)
        /bin/kill  -9 `ps -eo pid,command|grep ${synergy_daemon} 2>/dev/null|grep -v 'grep'|awk '{print $1}'` 2>/dev/null
        ;;
    esac
  }
}

alias ss='synergy_server'