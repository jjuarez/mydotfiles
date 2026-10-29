set -o pipefail
#set -x


ibm::utils::validate_icr_region() {
  local -r region="${1}"

  case ${region} in
    eu|us|global) return 0 ;;
    *) return 1
  esac
}

ibm::utils::validate_account() {
  local -r account="${1}"

  case ${account} in
    qc-master|qs-staging|qs-prod) return 0 ;;
    *) return 1
  esac
}

ibm::icr::login() {
  local -r account="${1}"
  local -r registry="${2}"
  local -rA IBMCLOUD_API_KEYS=(
    qc-master  "${QCMASTER_IBMCLOUD_API_KEY}"
    qs-staging "${QSSTAGING_IBMCLOUD_API_KEY}"
    qs-prod    "${QSPROD_IBMCLOUD_API_KEY}"
  )
  local -r api_key="${IBMCLOUD_API_KEYS[${account}]}"

  [[ -n "${api_key}" ]] || return 1

  echo "${api_key}" | docker login --username iamapikey --password-stdin "${registry}"
}


docker::retag() {
  local -r image="${1}"
  local -r account="${2:-qc-master}"
  local -r registry="${3:-global}"
  local mirror_image
  local -rA registries=(
    eu     "eu.icr.io"
    us     "us.icr.io"
    global "icr.io"
    )
  local -rA icr_namespaces=(
    qc-master  "quantum-mirror-images"
    qs-staging "qc-staging-ext-images"
    qs-prod    "qc-production-ext-images"
    )

  [[ -n "${image}" ]] || return 1
  ibm::utils::validate_icr_region "${registry}" || return 1
  ibm::utils::validate_account "${account}" || return 1

  mirror_image="${registries[${registry}]}/${icr_namespaces[${account}]}/${image}"
  docker image pull --platform linux/amd64 "${image}" || return 2
  docker image tag "${image}" "${mirror_image}" || return 3
  ibm::icr::login "${account}" "${registries[${registry}]}" || return 4
  docker image push --platform linux/amd64 "${mirror_image}" || return 5
}

# autoloads
autoload docker::retag

# aliases
