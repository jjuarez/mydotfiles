##
# Functions
#
synergy_server() {

  [ -x /usr/bin/synergys ] && [ -r ~/.synergy.conf ] && {

    case ${1} in
      start)
        /usr/bin/synergys --name makalu &>/dev/null
        ;;
      stop)
        kill `ps -eo pid,command|grep /usr/bin/synergys 2>/dev/null|grep -v 'grep'|awk '{print $1}'` 2>/dev/null
        ;;
    esac
  }
}

alias ss='synergy_server'
