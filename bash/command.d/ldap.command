##
# LDAP Stuff
#
LDAP_SERVER="ldap://ldap.redcorp.privada.csic.es"
LDAP_BASE="idnc=usuarios,dc=csic,dc=es"
LDAP_USER="cn=admin,dc=csic,dc=es"
LDAP_PASSWORD=`head -1 ${HOME}/.ldap.credentials`
AUDIT_ATTRS="creatorsName createTimestamp modifiersName modifyTimestamp"


__find() { 

  /usr/bin/ldapsearch -LLL -x -H ${LDAP_SERVER} -x -D ${LDAP_USER} -w ${LDAP_PASSWORD} -b ${LDAP_BASE} ${@} 2>/dev/null 
}

__ldap_uid2dn() {

  [ -n "${1}" ] && __find uid=${1} dn|sed -e 's/^dn: //g'|tr -d '\n'
}

__ldap_id2dn() {

  [ -n "${*}" ] && __find idinterviniente=${1} dn|sed -e 's/^dn: //g'|tr -d '\n'
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

ldap_audit_uid() {

  [ -n "${1}" ] && __find uid=${1} ${AUDIT_ATTRS}
}

ldap_audit_id() {

  [ -n "${1}" ] && __find idinterviniente=${1} ${AUDIT_ATTRS}
}

ldap_modify() {

  [ -r "${1}" ] && /usr/bin/ldapmodify -x -H ${LDAP_SERVER} -D ${LDAP_USER} -W -c -f "${1}"
}

ldap_delete_id() {
  
  [ -z "${1}" ] && exit 1

  # This not works with base64 DistinguisedNames
  DN=`__ldap_id2dn ${1}`

  [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_SERVER} -D ${LDAP_USER} -W "${DN}"
}

ldap_delete_uid() {
  
  [ -z "${1}" ] && exit 

  # This not works with base64 DistinguisedNames
  DN=`__ldap_uid2dn ${1}`

  [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_SERVER} -D ${LDAP_USER} -W "${DN}"
}
