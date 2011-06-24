##
# Functions
#
synergys() {

  synergy_server="/Applications/QuickSynergy.app/Contents/Resources/synergys"
 #synergy_server="/usr/local/bin/synergys"

  [ -x "${synergy_server}" ] && {

    case ${1} in
      dstart)
        ${synergy_server} --no-daemon --debug DEBUG --name `hostname -s`

      start)
        ${synergy_server} --name `hostname -s`
        ;;

      stop)
        /bin/kill -15 `/bin/ps -eo pid,command|grep ${synergy_server}|grep -v 'grep'|awk '{ print $1 }'` 2>/dev/null
        ;;
    esac
  }
}
