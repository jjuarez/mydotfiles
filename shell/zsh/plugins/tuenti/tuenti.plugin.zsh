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

ssh_to() {

  local bastion_host="bastion"
  local target_host=${1}
  local remote_command=${2:-""}

  [[ -n "${target_host}" ]] && /usr/bin/ssh -t ${bastion_host} /usr/bin/ssh ${target_host} "${remote_command}"
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

find_vm() {

  local vm=${1}
  local kvm_hosts_list=${2:-'/srv/config/virt_server_list'}
  local user=${3:-'root'}
  local return_value=1

  [[ -z "${vm}" ]] && return ${return_value}

  [[ -f "${kvm_hosts_list}" ]] || return ${return_value}

  if contains_wildcards "${vm}"; then
    for kvm in $(cat ${kvm_hosts_list}); do

      echo -n "Looking for virtual machine: ${vm} in kvm host: ${kvm}..."
      ssh_to ${user}@${kvm} "/usr/bin/virsh list | /bin/grep -E ${vm}" &>/dev/null && { echo " Found it!"; return_value=0 } || { echo }
    done
  else
    for kvm in $(cat ${kvm_hosts_list}); do

      echo -n "Looking for virtual machine: ${vm} in kvm host: ${kvm}..."
      ssh_to ${user}@${kvm} "/usr/bin/virsh list | /bin/grep -E ${vm}" &>/dev/null && { echo " Found it!"; return_value=0; break } || { echo }
    done
  fi

  return ${return_value}
}


##
# Aliases
alias sshto='ssh_to'

