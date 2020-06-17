# vi: set ft=zsh :
# set -eux -o pipefail 

[[ -d "${HOME}/.helm" ]] || mkdir -p "${HOME}/.helm/clusters"

# Kubernetes
k8s::kops() {
  local cluster=${1}

  case ${cluster} in
    mgmt)
      export AWS_PROFILE="mgmt"
      export KOPS_STATE_STORE="s3://commonk8s-clarity-mgmt-pro"

      [[ -s "${HOME}/.env.Clarity.tf.mgmt.pro" ]] || return 1
      source "${HOME}/.env.Clarity.tf.mgmt.pro"
      ;;

    stg)
      export AWS_PROFILE="saas-stg"
      export KOPS_STATE_STORE="s3://k8s-clarity-saas-stg"

      [[ -s "${HOME}/.env.Clarity.tf.saas.stg" ]] || return 1
      source "${HOME}/.env.Clarity.tf.saas.stg"
      ;;

    dev|pre|prod)
      # Back to the root account we have to clean the environment
      export AWS_PROFILE="default"  # root account
      export KOPS_STATE_STORE="s3://kubernetes.${cluster}.clarity.ai"
      export KOPS_RUN_OBSOLETE_VERSION="yes"

      [[ -s "${HOME}/.env.Clarity.tf.root.stg" ]] || return 1
      source "${HOME}/.env.Clarity.tf.root.stg"
      ;;

    *)
      return 1
      ;;
  esac
}

k8s::helm() {
  local cluster=${1}

  [[ -d "${HOME}/.helm/clusters/${cluster}" ]] || return 1

  case ${cluster} in
    stg|mgmt|dev|pre|prod)
      [[ -d "${HOME}/.helm/clusters/${cluster}" ]] || return 1
      export HELM_HOME="${HOME}/.helm/clusters/${cluster}"
      ;;

    *)
      return 1
      ;;
  esac
}

k8s::switch() {
  local cluster=${1}
  local namespace=${2:-'clarity'}

  case "${cluster}" in
    dev|pre|prod)
      k8s::kops ${cluster}
      k8s::helm ${cluster}
      kubie ctx ${cluster}.clarity.ai -n ${namespace}
      ;;

    mgmt)
      k8s::kops ${cluster}
      k8s::helm ${cluster}
      kubie ctx common.${cluster}.clarity.ai -n ${namespace}
      ;;

    stg)
      k8s::kops ${cluster}
      k8s::helm ${cluster}
      kubie ctx k8s.${cluster}.clarity.ai -n ${namespace}
      ;;

    *)
      return 1
      ;;
  esac
}

# ::alias:
alias k='kubectl'
alias ksw='k8s::switch'
