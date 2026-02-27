set -o pipefail

#
# General utilities
#
utils::panic() {
  local -r message="${1}"
  local -r exit_code="${2}"

  [[ -n "${message}" ]] && echo -e "${message}"
  return "${exit_code}"
}

#
# Configurations
#
DEFAULT_CLOUD_DEPLOYMENT_WORKSPACE="${HOME}/workspace/ibm/quantum/projects/infra/cloud-deployment"
DEFAULT_PLAN_FILENAME="this.tfplan"

CLOUD_DEPLOYMENT_WORKSPACE=${CLOUD_DEPLOYMENT_WORKSPACE:-${DEFAULT_CLOUD_DEPLOYMENT_WORKSPACE}}
PLAN_FILENAME=${PLAN_FILENAME:-${DEFAULT_PLAN_FILENAME}}

[[ -d "${CLOUD_DEPLOYMENT_WORKSPACE}" ]] || utils::panic "Warning: I couldn't find the ${CLOUD_DEPLOYMENT_WORKSPACE}" 1
[[ -x "${CLOUD_DEPLOYMENT_WORKSPACE}/tools/tfinit.sh" ]] || utils::panic "Warning: I couldn't find the ${CLOUD_DEPLOYMENT_WORKSPACE}/tfinit.sh script" 2


#
# Wrappers
#
terraform::state::wipeoff() {
  for fp in .terraform this.tfplan this.tfplan.json this.tfplan.md cloud_keys.auto.tfvars; do
    find ${CLOUD_DEPLOYMENT_WORKSPACE} -name "${fp}" -print|xargs rm -fr
  done
}

terraform::state::init() {
  [[ -x "${CLOUD_DEPLOYMENT_WORKSPACE}/tools/tfinit.sh" ]] && "${CLOUD_DEPLOYMENT_WORKSPACE}/tools/tfinit.sh" "${@}"
}

terraform::state::cleanup() {
  [[ -d ".terraform" ]] && rm -fr .terraform
  [[ -f "${PLAN_FILENAME}" ]] && rm -f "${PLAN_FILENAME}"
}

terraform::state::upgrade() {
  terraform::state::cleanup
  ${CLOUD_DEPLOYMENT_WORKSPACE}/tools/tfinit.sh --upgrade --force
}

terraform::state::save() {
  terraform state pull > $(date +%F)-terraform-state-backup.tfstate
}

terraform::plan() {
  # We need to pass all the command line, for example to allow the alias to work with targets
  terraform plan --lock=false --out="${PLAN_FILENAME}" "${@}"
}

terraform::apply() {
  [[ -f "${PLAN_FILENAME}" ]] && terraform apply "${PLAN_FILENAME}"
}


# autoloads
autoload terraform::state::cleanup
autoload terraform::state::init
autoload terraform::state::save
autoload terraform::state::upgrade
autoload terraform::plan
autoload terraform::apply


# aliases
alias tf='terraform'
alias tff='terraform fmt'
alias tfv='terraform validate'
alias tfa='terraform::apply'
alias tfc='terraform::state::cleanup'
alias tfi='terraform::state::init'
alias tfs='terraform::state::save'
alias tfu='terraform::state::upgrade'
alias tfw='terraform::state::wipeoff'
alias tfp='terraform::plan'
