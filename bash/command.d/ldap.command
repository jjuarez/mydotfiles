##
# LDAP Stuff
LDAP_READ_SERVER="ldap://boj.redcorp.privada.csic.es"
LDAP_WRITE_SERVER="ldap://ldap.redcorp.privada.csic.es"
USERS_BASE="idnc=usuarios,dc=csic,dc=es"
READ_USER="cn=casuser,dc=csic,dc=es"
WRITE_USER="cn=admin,dc=csic,dc=es"
AUDIT_ATTRS="creatorsName createTimestamp modifiersName modifyTimestamp"
NI_PASSWORD=`head -1 ${HOME}/.ldap.credentials`


__find() { 

  /usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -D ${READ_USER} -w ${NI_PASSWORD} -b ${USERS_BASE} ${@} 2>/dev/null 
}

ldap_find_user() { 

  [ -n "${*}" ] && __find "${*}"
}

ldap_find_uid() {

  [ -n "${1}" ] && __find uid=${1}
}

ldap_find_id() { 

  [ -n "${1}" ] && __find idinterviniente=${1}
}

ldap_id2dn() {

  [ -n "${*}" ] && __find idinterviniente=${1} dn 
}

ldap_audit_uid() {

  [ -n "${1}" ] && __find uid=${1} ${AUDIT_ATTRS}
}

ldap_audit_id() {

  [ -n "${1}" ] && __find idinterviniente=${1} ${AUDIT_ATTRS}
}

ldap_modify() {

  [ -r "${1}" ] && /usr/bin/ldapmodify -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W -c -f "${1}"
}

ldap_delete_id() {
  
  [ -z "${1}" ] && exit 1

  # This not works with base64 DistinguisedNames
  [ -n "`ldap_id2dn ${1}`" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
}

ldap_delete_uid() {
  
  [ -z "${1}" ] && exit 

  # This not works with base64 DistinguisedNames
  [ -n "`ldap_uid2dn ${1}`" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
}