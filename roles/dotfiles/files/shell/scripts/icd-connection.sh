#!/usr/bin/env bash

set -eu -o pipefail

# vim: ft=bash
#
: <<COMMENT
Take a look at the README.md file
COMMENT

declare -r CREDENTIALS_FILE="credentials.json"


IBMCLOUD_CLI="$(command -v ibmcloud 2>/dev/null)"
JQ="$(command -v jq 2>/dev/null)"

MONGODB_URI=""
POSTGRESQL_URI=""
REDIS_URI=""


utils::console() {
  set +x
  local -r message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}"
}

utils::panic() {
  set +x
  local -r message="${1}"
  local -r exit_code="${2}"

  utils::console "${message}"
  exit "${exit_code}"
}

utils::preflight() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "This script needs IBM Cloud CLI tool" 1
  [[ -x "${JQ}" ]] || utils::panic "This script needs the jq tool" 1
  [[ -n "${IBMCLOUD_API_KEY}" ]] || utils::panic "This script needs an IBMCLOUD_API_KEY environment variable" 2
  [[ -n "${IBMCLOUD_SME}" ]] || utils::panic "This script needs an IBM Cloud Secrets Manager environment variable (IBMCLOUD_SME)" 2
}

utils::cleanup() {
  local -r db="${1}"
  local -r cf="./${db}/${CREDENTIALS_FILE}"

  if [[ ! -d "${db}" ]]; then
    mkdir "${db}"
  else
    if [[ -f "${cf}" ]]; then
      rm "${cf}"
    fi
  fi
}

utils::login() {
  ibmcloud login --no-region -g "" || utils::panic "We couldn't login" 3
  ibmcloud sm config set service-url "${IBMCLOUD_SME}" --quiet
}

sm::credentials::check() {
  local -r db="${1}"
  local -r cf="./${db}/${CREDENTIALS_FILE}"

  ibmcloud sm secret-by-name \
    --secret-type service_credentials \
    --secret-group-name infra_icd_operations \
    --name "${db}-infra" \
    --output=json >/dev/null 2>&1
}

sm::credentials::get() {
  local -r db="${1}"
  local -r cf="./${db}/${CREDENTIALS_FILE}"

  utils::console "Saving the service credentials..."

  ibmcloud sm secret-by-name \
    --secret-type service_credentials \
    --secret-group-name infra_icd_operations \
    --name "${db}-infra" \
    --output=json > "${cf}"
}

sm::credentials::create() {
  local -r db="${1}"
  local -r cf="./${db}/${CREDENTIALS_FILE}"
  local db_crn
  local sm_secret_group_id

  utils::console "Creating the service credentials..."

  db_crn=$(ibmcloud resource service-instance "${db}" --output json|jq -r '.[0].crn')

  if [[ -z "${db_crn}" ]]; then
    utils::panic "We couldn't create the secret" 2
  fi

  sm_secret_group_id=$(ibmcloud sm secret-groups --output=json|jq -r '.secret_groups[]|select(.name=="infra_icd_operations").id')
  echo "debug: ${sm_secret_group_id}"

  ibmcloud sm secret-create \
    --secret-type service_credentials \
    --secret-group-id "${sm_secret_group_id}" \
    --secret-name "${db}-infra" \
    --secret-description "Infrastructure temporary access for ${db}" \
    --secret-source-service "{\"instance\": {\"crn\": \"${db_crn}\"}, \"role\": {\"crn\": \"crn:v1:bluemix:public:iam::::serviceRole:Writer\"}}" \
    --output=json > "${cf}"
}

db::config::postgresql() {
  local -r cf="${1}"

  POSTGRESQL_URI=$(jq -r '.credentials.connection.postgres.composed[0]' "${cf}")
  export POSTGRESQL_URI="${POSTGRESQL_URI//verify-full/require}"
  # shellcheck disable=SC2016
  utils::console 'command: psql ${POSTGRESQL_URI}'
}

db::config::mongodb() {
  local -r cf="${1}"

  MONGODB_URI=$(jq -r '.credentials.connection.mongodb.composed[0]' "${cf}")
  export MONGODB_URI="${MONGODB_URI}&tlsAllowInvalidCertificates=true"
  # shellcheck disable=SC2016
  utils::console 'command: mongosh ${MONGODB_URI}'
}

db::config::redis() {
  local -r cf="${1}"

  REDIS_URI=$(jq -r '.credentials.connection.rediss.composed[0]' "${cf}")
  export REDIS_URI
  # shellcheck disable=SC2016
  utils::console 'command: redis-cli --insecure -u ${REDIS_URI}'
}

db::config() {
  local db="${1}"
  local cf="${db}/${CREDENTIALS_FILE}"

  utils::preflight
  utils::console "Creating access to ${db}..."

  utils::cleanup "${db}"
  utils::login

  if sm::credentials::check "${db}"; then
    sm::credentials::get "${db}"
  else
    sm::credentials::create "${db}"
  fi

  echo "Configuring access to ICD: ${db}..."
  case ${db} in
    *mongo*) db::config::mongodb "${cf}" ;;
     *psql*) db::config::postgresql "${cf}" ;;
    *redis*) db::config::redis "${cf}" ;;
          *) utils::panic "DB type ${db} it not supported" 4
  esac
}
