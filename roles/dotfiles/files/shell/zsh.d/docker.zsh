set -o pipefail
#set -x


ibm::icr::login() {
  local -r account="${1}"
  local -r registry="${2}"
  local -rA IBMCLOUD_API_KEYS=(
    qc-experimental "${QCEXPERIMENTAL_IBMCLOUD_API_KEY}"
    qc-master       "${QCMASTER_IBMCLOUD_API_KEY}"
    qs-staging      "${QSSTAGING_IBMCLOUD_API_KEY}"
    qs-prod         "${QSPRODUCTION_IBMCLOUD_API_KEY}"
  )
  local -r api_key="${IBMCLOUD_API_KEYS[${account}]}"

  if [[ -z "${api_key}" ]]; then
    echo "Unknown account or missing API key: ${account}"
    return 1
  fi

  echo "${api_key}" | docker login --username iamapikey --password-stdin "${registry}"
}

docker::retag() {
  local -r registry="icr.io"
  local -r namespace="quantum-mirror-images"
  local -r image="${1}"
  local -r account="${2:-qc-master}"
  local -r mirror_image="${registry}/${namespace}/${image}"

  [[ -n "${image}" ]] || return 1

  docker image pull --platform linux/amd64 "${image}"        || return 1
  docker image tag "${image}" "${mirror_image}"              || return 1
  ibm::icr::login "${account}" "${registry}"                 || return 1
  docker image push --platform linux/amd64 "${mirror_image}"
}

# autoloads
autoload docker::retag

# aliases
