##
# LDAP Stuff
##
LDAP_SEARCH=/usr/bin/ldapsearch
LDAP_DELETE=/usr/bin/ldapdelete
LDAP_MODIFY=/usr/bin/ldapmodify
LDAP_READ_SERVER="ldaps://menta.csic.es"
LDAP_WRITE_SERVER="ldap://ldap.redcorp.privada.csic.es"
USERS_BASE="idnc=usuarios,dc=csic,dc=es"
READ_USER="cn=casuser,dc=csic,dc=es"
WRITE_USER="cn=admin,dc=csic,dc=es"
NI_PASSWORD=$(head -1 ${HOME}/.ldap.credentials)


__find() { 

  /usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -D ${READ_USER} -w ${NI_PASSWORD} -b ${USERS_BASE} ${@} 2>/dev/null 
}

ldap_find_user() { 

  [ -n "${*}" ] && __find "${*}"
}

ldap_find_uid() {

  [ -n "${1}" ] && __find uid="${1}" 
}

ldap_find_id() { 

  [ -n "${1}" ] && __find idInterviniente="${1}" 
}

ldap_id2dn() { 

  [ -n "${*}" ] && __find idInterviniente=${1} dn 
}

ldap_audit_entry() {

  [ -n "${*}" ] && __find uid=${1} creatorsName createTimestamp modifiersName modifyTimestamp 
}

ldap_delete_id() {
  
  [ -n "${1}" ] && {

    # This not works with base64 DistinguisedNames
    DN=`/usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -Dcn=casuser,dc=csic,dc=es -w ${NI_PASSWORD} -b ${USERS_BASE} idinterviniente="${1}" dn 2>/dev/null|grep ^dn:|sed 's/dn: //g'`
    [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
  }
}

ldap_delete_uid() {
  
  [ -n "${1}" ] && {

    # This not works with base64 DistinguisedNames
    DN=`/usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -Dcn=casuser,dc=csic,dc=es -w ${NI_PASSWORD} -b ${USERS_BASE} uid="${1}" dn 2>/dev/null|grep ^dn:|sed 's/dn: //g'`
    [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
  }
}

ldap_modify() {

  [ -r "${1}" ] && {

    /usr/bin/ldapmodify -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W -c -f "${1}"
  }
}
