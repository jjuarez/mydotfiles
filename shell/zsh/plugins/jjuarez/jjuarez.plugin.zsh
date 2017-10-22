##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

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
  local instance_id=""

  [[ -n "${image_id}"  ]] || return 1
  [[ -n "${sg_id}"     ]] || return 2
  [[ -n "${subnet_id}" ]] || return 3

  instance_id=$(aws ec2 run-instances --image-id "${image_id}" --count 1 --instance-type "${instance_type}" --key-name "${key_name}" --security-group-ids "${sg_id}" --subnet-id "${subnet_id}" --associate-public-ip-address|jq '.Instances[].InstanceId'|sed -e 's/"//g')

  [[ -n "${instance_id}" ]] || return 4

  aws ec2 create-tags --resources ${instance_id} --tags Key=Name,Value="Serverspec TEST instance"
}

##
# AWS retrieves the IP address of the instances that belongs to an ASG
# aws::get_asg_ips() {
#  local asg_name="${1}"
#  local instances=""
#
#  [[ -n "${asg_name}" ]] || return 5
#
#  instances=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "${asg_name}"|grep InstanceId|cut -d: -f2|sed -e 's/"//g'|sed -e 's/,//g')
#
#  [[ -n "${instances}" ]] || return 6
#
#  for i in "${instances}"; do
#    aws ec2 describe-instances --instance-ids "${i}"|grep PrivateIpAddress|cut -d" " -f2|head -1|cut -d, -f1|sed -e 's/"//g'
#  done
# }

##
# Puppet
puppet::pc() {
 local pc_directory="${HOME}/workspace/4iq/devops/cm/puppet/modules/puppet_control"

 [[ -d "${pc_directory}" ]] && cd "${pc_directory}"
}

terraform::iac() {
 local iac_directory="${HOME}/workspace/4iq/devops/infrastructure/iac"

 [[ -d "${iac_directory}" ]] && cd "${iac_directory}"
}

terraform::mgmt() {
 local mgmt_directory="${HOME}/workspace/4iq/devops/infrastructure/iac_management"

 [[ -d "${mgmt_directory}" ]] && cd "${mgmt_directory}" 
}

##
# Aliases
alias pc='puppet::pc'
alias iac='terraform::iac'
alias mgmt='terraform::mgmt'
alias li='aws::launch_instance'
alias archive='fs::archive'

