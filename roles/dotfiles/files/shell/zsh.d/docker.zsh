set -o pipefail
#set -x


ibm::icr::login() {
  local -r account="${1}"
  local -r registry="${2}"
  local -rA IBMCLOUD_API_KEYS=(
    qc-master  "${QCMASTER_IBMCLOUD_API_KEY}"
    qs-staging "${QSSTAGING_IBMCLOUD_API_KEY}"
    qs-prod    "${QSPRODUCTION_IBMCLOUD_API_KEY}"
  )
  local -r api_key="${IBMCLOUD_API_KEYS[${account}]}"

  [[ -n "${api_key}" ]] || return 1

  echo "${api_key}" | docker login --username iamapikey --password-stdin "${registry}"
}


docker::retag() {
  local -r image="${1}"
  local -r account="${2:-qc-master}"
  local -r registry="${3:-global}"
  local -rA registries=(
    us     "us.icr.io"
    global "icr.io"
    )
  local -rA icr_namespaces=(
    qc-master  "quantum-mirror-images"
    qs-staging "qc-staging-ext-images"
    qs-prod    "qc-production-ext-images"
    )
  local -r mirror_image="${registries[${registry}]}/${icr_namespaces[${account}]}/${image}"

  [[ -n "${image}" ]] || return 1

  docker image pull --platform linux/amd64 "${image}" || return 2
  docker image tag "${image}" "${mirror_image}" || return 3

  ibm::icr::login "${account}" "${registries[${registry}]}" || return 4

  docker image push --platform linux/amd64 "${mirror_image}" || return 5
}

# autoloads
autoload docker::retag

# aliases
