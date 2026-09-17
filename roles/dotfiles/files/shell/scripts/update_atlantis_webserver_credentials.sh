#!/usr/bin/env bash

set -euo pipefail

declare -r SECRET_GROUP_NAME="infra_cicd"
declare -r SECRET_TYPE="username_password"
declare -r SECRET_NAME="atlantis-webserver-credentials"

declare -r ITEM_TITLE="Atlantis WebServer"
declare -r ITEM_VAULT="Employee"
declare -r ITEM_URL="https://atlantis.quantum-computing.ibm.com"

utils::panic() {
  local -r message="${1}"
  local -r exit_code="${2:-0}"

  [[ -n "${message}" ]] && {
    echo -e "${message}" >&2
    exit "${exit_code}"
  }
}

IBMCLOUD=$(command -v ibmcloud 2>/dev/null) || true
JQ=$(command -v jq 2>/dev/null) || true
OP=$(command -v op 2>/dev/null) || true
declare -r IBMCLOUD JQ OP

[[ -x "${IBMCLOUD}" ]] || utils::panic "No ibmcloud installed" 1
[[ -x "${JQ}" ]] || utils::panic "No jq installed" 1
[[ -x "${OP}" ]] || utils::panic "No op installed" 1

#
# ::main::
#
secret=$("${IBMCLOUD}" secrets-manager secret-by-name \
  --secret-group-name "${SECRET_GROUP_NAME}" \
  --secret-type "${SECRET_TYPE}" \
  --name "${SECRET_NAME}" \
  --output=json)

# The jq program references jq variables, not shell ones, so it stays single-quoted.
# shellcheck disable=SC2016
item=$("${JQ}" \
  --arg title "${ITEM_TITLE}" \
  --arg vault "${ITEM_VAULT}" \
  --arg url "${ITEM_URL}" \
  '{
     "title": $title,
     "category": "LOGIN",
     "vault": {
       "id": $vault
     },
     "fields": [
       {
         "id": "username",
         "type": "STRING",
         "purpose": "USERNAME",
         "label": "username",
         "value": .username
       },
       {
         "id": "password",
         "type": "CONCEALED",
         "purpose": "PASSWORD",
         "label": "password",
         "value": .password
       }
     ],
     "urls": [
       {
         "label": "website",
         "primary": true,
         "href": $url
       }
     ]
   }' <<<"${secret}")

if "${OP}" item get "${ITEM_TITLE}" --vault "${ITEM_VAULT}" >/dev/null 2>&1; then
  "${OP}" item delete "${ITEM_TITLE}" --vault "${ITEM_VAULT}" --archive
fi

echo "${item}" | "${OP}" item create --favorite <<<"${item}"
