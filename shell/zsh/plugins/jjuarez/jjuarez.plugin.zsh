##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 1

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}

##
# AWS
aws::launch_instance() {
  local image_id="${1}"
  local sg_id="${2}"
  local subnet_id="${3}"
  local instance_type=${4:-'t2.micro'}
  local key_name=${5:-'Systems'}

  [[ -n "${image_id}"  ]] || return 1
  [[ -n "${sg_id}"     ]] || return 1
  [[ -n "${subnet_id}" ]] || return 1

  instance_id=$(aws ec2 run-instances --image-id "${image_id}" --count 1 --instance-type "${instance_type}" --key-name "${key_name}" --security-group-ids "${sg_id}" --subnet-id "${subnet_id}" --associate-public-ip-address|jq '.Instances[].InstanceId'|sed -e 's/"//g')

  [[ -n "${instance_id}" ]] || return 1

  aws ec2 create-tags --resources ${instance_id} --tags Key=Name,Value="Serverspec TEST instance"
}

##
# Puppet
puppet::pc() {
 local pc_directory="${HOME}/workspace/4iq/devops/cm/puppet/modules/puppet_control" 

 [[ -d "${pc_directory}" ]] && cd "${pc_directory}" 
}

##
# Aliases
alias pc='puppet::pc'
alias li='aws::launch_instance'
alias archive='fs::archive'

