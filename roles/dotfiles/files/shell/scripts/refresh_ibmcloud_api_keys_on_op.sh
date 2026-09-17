#!/usr/bin/env bash

set -euo pipefail

declare -r ITEM_VAULT="Employee"
declare -r ITEM_URL="https://cloud.ibm.com"
declare -r ITEM_CATEGORY="API_CREDENTIAL"
# Custom concealed field holding the key. The category's built-in "credential"
# field is a designated field and cannot be renamed, so it is left unset.
declare -r ITEM_FIELD="APIKey"
declare -r ITEM_USERNAME="javier.juarez.martinez@ibm.com"

# Each entry is <environment variable holding the key>:<1Password item title>
declare -ra API_KEYS=(
  "QCMASTER_IBMCLOUD_API_KEY:IBM Cloud QC-Master"
  "QCEXPERIMENTAL_IBMCLOUD_API_KEY:IBM Cloud QC-Experimental"
  "QSSTAGING_IBMCLOUD_API_KEY:IBM Cloud QS-Staging"
  "QSPROD_IBMCLOUD_API_KEY:IBM Cloud QS-Prod"
)

utils::panic() {
  local -r message="${1}"
  local -r exit_code="${2:-1}"

  [[ -n "${message}" ]] && {
    echo -e "${message}" >&2
    exit "${exit_code}"
  }
}

JQ=$(command -v jq 2>/dev/null) || true
OP=$(command -v op 2>/dev/null) || true
declare -r JQ OP

[[ -x "${JQ}" ]] || utils::panic "No jq installed" 1
[[ -x "${OP}" ]] || utils::panic "No op installed" 1

op::item_json() {
  local -r title="${1}"
  local -r api_key="${2}"

  # The jq program references jq variables, not shell ones, so it stays single-quoted.
  # shellcheck disable=SC2016
  "${JQ}" -n \
    --arg title "${title}" \
    --arg vault "${ITEM_VAULT}" \
    --arg category "${ITEM_CATEGORY}" \
    --arg field "${ITEM_FIELD}" \
    --arg url "${ITEM_URL}" \
    --arg value "${api_key}" \
    --arg username "${ITEM_USERNAME}" \
    '{
       "title": $title,
       "category": $category,
       "vault": {
         "id": $vault
       },
       "fields": [
         {
           "id": "username",
           "type": "STRING",
           "label": "username",
           "value": $username
         },
         {
           "id": "apikey",
           "type": "CONCEALED",
           "label": $field,
           "value": $value
         }
       ],
       "urls": [
         {
           "label": "website",
           "primary": true,
           "href": $url
         }
       ]
     }'
}

op::refresh_item() {
  local -r title="${1}"
  local -r api_key="${2}"
  local old_id

  # Resolve the item being replaced up front, so it can be archived by UUID later.
  old_id=$("${OP}" item get "${title}" --vault "${ITEM_VAULT}" --format json 2>/dev/null |
    "${JQ}" -r '.id // empty') || true

  # Create the replacement before touching the old item: a failed create then
  # leaves the existing key in place instead of only in the archive. The key is
  # piped in rather than passed as an argument so it stays out of `ps` output.
  op::item_json "${title}" "${api_key}" | "${OP}" item create --favorite >/dev/null

  [[ -n "${old_id}" ]] && "${OP}" item delete "${old_id}" --vault "${ITEM_VAULT}" --archive

  return 0
}

#
# ::main::
#
for entry in "${API_KEYS[@]}"; do
  env_var="${entry%%:*}"
  item_title="${entry#*:}"
  api_key="${!env_var:-}"

  [[ -n "${api_key}" ]] || {
    echo "Skipping '${item_title}': ${env_var} is not set" >&2
    continue
  }

  op::refresh_item "${item_title}" "${api_key}"
  echo "Refreshed '${item_title}' from \${${env_var}}"
done
