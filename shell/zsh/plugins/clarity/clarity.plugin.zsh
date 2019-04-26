# vi: set ft=zsh :
declare -A K8S_ENVIRONMENTS=(
  [dev]=x [pre]=x [prod]=x
)

# Configuration
DNS=${DNS:-'clarity.ai'}
HELM_ROOT="${HOME}/.helm"

# Dependencies
KCTL=$(which kubectl 2>/dev/null)
KCTX=$(which kubectx 2>/dev/null)
KNS=$(which kubens 2>/dev/null)
KOPS=$(which kops 2>/dev/null)
HELM=$(which helm 2>/dev/null)

[[ -x "${KCTL}" ]] || return 1
[[ -x "${KCTX}" ]] || return 1
[[ -x "${KNS}"  ]] || return 1
[[ -x "${KOPS}" ]] || return 1
[[ -x "${HELM}" ]] || return 1


clarity::valid_environment() {
  local environment=${1}

  [[ -n "${K8S_ENVIRONMENTS[$environment]}" ]]
}

clarity::context() {
  local environment=${1}
  local namespace=${2}

  ${KCTX} ${environment}.${DNS}
  ${KNS} ${namespace}
}

clarity::kops() {
  local environment=${1}

  export KOPS_STATE_STORE="s3://kubernetes.${environment}.${DNS}"
}

clarity::helm() {
  local environment=${1}

  [[ -d "${HELM_ROOT}/clusters/${environment}.${DNS}" ]] || return 2

  export HELM_HOME="${HELM_ROOT}/clusters/${environment}.${DNS}"
}

clarity::test_cluster() {
  local test=${1}

  [[ "${test}" == "test" ]] && {
    echo "\nKubectl version:"
    ${KCTL} version

    echo "\nCustom namespaces:"
    ${KCTL} get namespaces --no-headers | grep -vE '(default|ingress|kube\-*)'

    echo "\nKops cluster:"
    ${KOPS} get cluster

    echo "\nHelm version:"
    ${HELM} version --tls
  }
}

#
# ::main::
#
clarity::k8s_switch() {
  local environment=${1:-dev}
  local namespace=${2:-clarity}
  local test=${3:-nope_thanks}

  if clarity::valid_environment ${environment}; then
    clarity::context ${environment} ${namespace}
    clarity::kops ${environment}
    clarity::helm ${environment}
    clarity::test_cluster ${test}
  else
    return 1
  fi
}

alias ksw='clarity::k8s_switch'
