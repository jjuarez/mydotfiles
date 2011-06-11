##
# LDAP Stuff
LDAP_CONFIG=${HOME}/.ldap.config.yml

##
# UID to DN transformation
ldap_uid2dn() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(uid=${1})" --attributes dn
}

##
# ID to DN transformation
ldap_id2dn() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(idinterviniente=${1})" --attributes dn
}

##
# Show some relevant information about an UID entry
ldap_audit_uid() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(uid=${1})" --audit
}

##
# Show some relevant information about an UID entry
ldap_audit_id() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(idinterviniente=${1})" --audit
}

##
# Search in free form
ldap_find_user() { 

  [ -s ${LDAP_CONFIG} ] && lsu --config ${LDAP_CONFIG} "${@}"
}
