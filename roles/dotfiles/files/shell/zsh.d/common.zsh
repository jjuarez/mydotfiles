#set -u -o pipefail
#set -x
LSOFT=$(command -v lsof 2>/dev/null)


common::kill_port() {
  local -i port=${1}
  local -r protocol="${2:-TCP}"

  [[ -x "${LSOFT}" ]] || return 1
  [[ -n "${port}"  ]] && kill -TERM $(${LSOFT} -t -i ${protocol}:${port})
}


# autoloads
autoload common::kill_port

# aliases
alias killport='common::kill_port'
