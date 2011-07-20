##
# Functions
#
synergy_server() {

 #synergy_daemon="/Applications/QuickSynergy.app/Contents/Resources/synergys"
  local synergy_daemon="/usr/local/bin/synergys"

  [ -x "${synergy_daemon}" ] && {

    case ${1} in
      dstart)
        ${synergy_daemon} --no-daemon --debug DEBUG --name `hostname -s`
        ;;
      start)
        ${synergy_daemon} --daemon --restart --debug ERROR --name `hostname -s`
        ;;
      stop)
        /bin/kill -15 `ps -eo pid,command|grep ${synergy_daemon}|grep -v 'grep'|awk '{print $1}'` 2>/dev/null
        ;;
      kill)
        /bin/kill  -9 `ps -eo pid,command|grep ${synergy_daemon}|grep -v 'grep'|awk '{print $1}'` 2>/dev/null
        ;;
    esac
  }
}

alias ss='synergy_server'
