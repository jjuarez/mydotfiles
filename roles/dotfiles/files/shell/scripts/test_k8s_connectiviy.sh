#!/usr/bin/env bash

set -eu -o pipefail
#set -x

declare -r KUBECONFIG_DIRECTORY="${HOME}/.kube"
declare -r KUBECONFIG_PATTERN="yml"

CLUSTER_KUBECONFIG_LIST=""


utils::console() {
  local message="${1}"

  [[ -n "${message}" ]] && 2>&1 echo -en "${message}"
}

utils::panic() {
  local message="${1}"
  local exit_code="${2}"

  [[ -n "${message}" ]] && {
    2>&1 echo -en "${message}"
    exit "${exit_code}"
  }
}

clusters::load_configs() {
  CLUSTER_KUBECONFIG_LIST=$(find "${KUBECONFIG_DIRECTORY}" -type f -name "*.${KUBECONFIG_PATTERN}" -print)
}

clusters::test_connectivity() {
  local cluster_config="${1}"

  if [[ -f "${cluster_config}" ]]; then
    KUBECONFIG=${cluster_config} "kubectl" cluster-info
  else
    return 1
  fi
}

main() {
  clusters::load_configs

  [[ -n "${CLUSTER_KUBECONFIG_LIST}" ]] || utils::panic "No clusters to test" 1

  for ckc in ${CLUSTER_KUBECONFIG_LIST}; do
    cluster_pretty_name=$(basename -s ".${KUBECONFIG_PATTERN}" "${ckc}")
    utils::console "*** Cluster: ${cluster_pretty_name} ***\n"
    clusters::test_connectivity "${ckc}"
  done
}

#
# ::main::
#
main
