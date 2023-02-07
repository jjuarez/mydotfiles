#!/usr/bin/env bash

set -eu -o pipefail
#set -x

declare -r KUBECONFIG_DIRECTORY="${HOME}/.kube"
declare -r KUBECONFIG_PATTERN="yml"

CLUSTER_KUBECONFIG_LIST=""


clusters::load_configs() {
  CLUSTER_KUBECONFIG_LIST=$(find "${KUBECONFIG_DIRECTORY}" -type f -name "*.${KUBECONFIG_PATTERN}" -print)
}


clusters::test() {
  [[ -n "${CLUSTER_KUBECONFIG_LIST}" ]] && {
    for ckc in ${CLUSTER_KUBECONFIG_LIST}; do
      cluster_pretty_name=$(basename -s ".${KUBECONFIG_PATTERN}" "${ckc}")
      echo ">>> Cluster: ${cluster_pretty_name}"
      KUBECONFIG=${ckc} "kubectl" cluster-info || echo "Error connecting"
    done
  }
}


#
# ::main::
#
clusters::load_configs
clusters::test
