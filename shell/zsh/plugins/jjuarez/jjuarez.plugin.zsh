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
  local configuration_file=${1:-"${HOME}/.aws_plugin_instance.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"

  [[ -n "${image_id}" ]] || return 2
  [[ -n "${subnet_id}" ]] || return 3
  [[ -n "${sg_id}" ]] || return 4
  [[ -n "${instance_type}" ]] || return 5
  [[ -n "${key_name}" ]] || return 6

  instance_id=$(aws ec2 run-instances --image-id "${image_id}" --count 1 --instance-type "${instance_type}" --key-name "${key_name}" --security-group-ids "${sg_id}" --subnet-id "${subnet_id}" --associate-public-ip-address|jq '.Instances[].InstanceId'|sed -e 's/"//g')

  [[ -n "${instance_id}" ]] || return 7

  aws ec2 create-tags --resources ${instance_id} --tags Key=Name,Value="Serverspec TEST instance"
}

aws::list_amis() {
  local configuration_file=${1:-"${HOME}/.aws_plugin_instance.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"
  aws ec2 describe-images --owners ${owner} | jq '.Images[] | { name: .Name, id: .ImageId }'
}

terraform::stack() {
 local dir="${HOME}/workspace/fon/devops/infra/iac_stack"

 [[ -d "${dir}" ]] && cd "${dir}"
}

terraform::stack_live() {
 local dir="${HOME}/workspace/fon/devops/infra/iac_live"

 [[ -d "${dir}" ]] && cd "${dir}"
}

##
# Aliases
alias launch_instance='aws::launch_instance'
alias list_amis='aws::list_amis'
alias stack='terraform::stack'
alias stack_live='terraform::live'
alias archive='fs::archive'

