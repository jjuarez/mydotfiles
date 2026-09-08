#!/usr/bin/env bash

IBMCLOUD=$(command -v ibmcloud 2>/dev/null)

declare -r SECRET_GROUP_NAME="infra_cicd"
declare -r SECRET_TYPE="username_password"
declare -r SECRET_NAME="atlantis-webserver-credentials"

utils::panic() {
  local -r message="${1}"
  local -r exit_code=${2:-0}

  [[ -n "${message}" ]] && {
    echo -e "${message}"
    exit "${exit_code}"
  }
}

[[ -x "${IBMCLOUD}" ]] || utils::panic "No ibmcloud installed" 1

#
# ::main::
#
ibmcloud secrets-manager secret-by-name --secret-group-name "${SECRET_GROUP_NAME}" --secret-type "${SECRET_TYPE}" --name "${SECRET_NAME}" --output=json |
  jq ' 
    { 
       "title": "Atlantis WebServer",
       "category": "LOGIN",
       "vault": {
          "id": "Employee"
       },
       "fields": [
         {
            id: "username",
            type: "STRING",
            "purpose": "USERNAME",
            label: "username",
            value: "admin"
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
            "href": "https://atlantis.quantum-computing.ibm.com"
          }
       ]
    }
' |
  op item create
