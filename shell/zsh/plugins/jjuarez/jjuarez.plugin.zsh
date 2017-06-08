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

archive() {

  local directory=${1}

  [[ -d "${directory}" ]] || return 1

  tar -czvf "${directory}"{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}

rmd() {

  pandoc ${1} | lynx -stdin
}

ssh_connect() {

  local aws_host=${1}
  local ssh_user=${2:-'centos'}
  local ssh_key_file=${3:-$HOME/.ssh/Systems.pem}

  [[ -n "${aws_host}" ]] || return 1
  [[ -f "${ssh_key_file}" ]] || return 2

  /usr/bin/ssh -l ${ssh_user} -i "${ssh_key_file}" ${aws_host}
}


