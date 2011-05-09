##
# LDAP Stuff
LDAP_CONFIG=${HOME}/.ldap.config

ldap_uid2dn() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(uid=${1})" --attributes dn
}

ldap_audit_uid() {

  [ -s ${LDAP_CONFIG} ] && [ -n "${1}" ] && lsu --config ${LDAP_CONFIG} --filter "(uid=${1})" --audit
}

ldap_find_user() { 

  [ -s ${LDAP_CONFIG} ] && lsu --config ${LDAP_CONFIG} ${*}
}
