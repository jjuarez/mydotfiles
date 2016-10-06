##
# Data
wildcards=( '*' '.' '?' '|' ']' '[' )

##
# Functions
contains_wildcards() {

  local str=${1}

  for w in "${wildcards[@]}"; do
    [[ ${str} == *"${w}"* ]] || return 0
  done

  return 1
}


is_alive() {

  local target_host=${1}
  local timeout=5
  local result=1

  [[ -n "${target_host}" ]] && { ping -q -c 1 -W ${timeout} ${target_host} &>/dev/null; result=${?} } 

  return ${result}
}

is_port_open() {

  local target_host=${1}
  local port=${2}
  local timeout=2
  local result=1

  [[ -n "${target_host}" ]] && { nc -z -w ${timeout} ${target_host} ${port} &>/dev/null; result=${?} } 

  return ${result}
}

slave_status() {

  local db_host=${1}

  [[ -n "${db_host}" ]] && mysql -A -h ${db_host} mysql -e "show slave status\G;"
}

mcd() { 

  local directory=${1}

  [[ -n "${directory}" ]] || return 1 

  mkdir -p "${directory}" && cd "${directory}"
}

archive() {

  local directory=${1}

  [[ -d "${directory}" ]] || return 1

  tar -czvf "${directory}"{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}

##
# Aliases
alias sshto='ssh_to'

