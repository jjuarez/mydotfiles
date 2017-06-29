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


##
# AWS
ssh_aws() {
  local aws_host=${1}
  local ssh_user=${2:-'centos'}
  local ssh_key_file=${3:-$HOME/.ssh/Systems.pem}

  [[ -n "${aws_host}" ]] || return 1
  [[ -f "${ssh_key_file}" ]] || return 2

  /usr/bin/ssh -l ${ssh_user} -i "${ssh_key_file}" ${aws_host}
}

launch_test_instance() {
  local image_id="${1}"
  local sg_id="${2}"
  local subnet_id=${3:-'subnet-ab288497'}
  local instance_type=${4:-'t2.micro'}

  instance_id=$(aws ec2 run-instances --image-id "${image_id}" --count 1 --instance-type "${instance_type}" --security-group-ids "${sg_id}" --subnet-id "${subnet_id}" --associate-public-ip-address 2>/dev/null|jq '.Instances[].InstanceId'|sed -e 's/"//g')

  [[ -n "${instance_id}" ]] || return 1

  aws ec2 create-tags --resources ${instance_id} --tags Key=Name,Value="Packer serverspec test"
}

