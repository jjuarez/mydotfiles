##
# LDAP Stuff
##
LDAP_SEARCH=/usr/bin/ldapsearch
LDAP_DELETE=/usr/bin/ldapdelete
LDAP_MODIFY=/usr/bin/ldapmodify
LDAP_READ_SERVER="ldaps://menta.csic.es:636"
LDAP_WRITE_SERVER="ldap://ldap.redcorp.privada.csic.es"
USERS_BASE="idnc=usuarios,dc=csic,dc=es"
READ_USER="cn=casuser,dc=csic,dc=es"
WRITE_USER="cn=admin,dc=csic,dc=es"


__find() { 

  /usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -D ${READ_USER} -w secret -b ${USERS_BASE} ${@} 2>/dev/null 
}

finduser() { 

  [ -n "${*}" ] && __find "${*}"
}

finduid() {

  [ -n "${1}" ] && __find uid="${1}" 
}

findid() { 

  [ -n "${1}" ] && __find idInterviniente="${1}" 
}

id2dn() { 

  [ -n "${*}" ] && __find idInterviniente=${1} dn 
}

audit_entry() {

  [ -n "${*}" ] && __find uid=${1} creatorsName createTimestamp modifiersName modifyTimestamp 
}

deleteid() {
  
  [ -n "${1}" ] && {

    # This not works with base64 DistinguisedNames
    DN=`/usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -Dcn=casuser,dc=csic,dc=es -w **** -b ${USERS_BASE} idinterviniente="${1}" dn 2>/dev/null|grep ^dn:|sed 's/dn: //g'`
    [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
  }
}

deleteuid() {
  
  [ -n "${1}" ] && {

    # This not works with base64 DistinguisedNames
    DN=`/usr/bin/ldapsearch -LLL -x -H ${LDAP_READ_SERVER} -x -Dcn=casuser,dc=csic,dc=es -w **** -b ${USERS_BASE} uid="${1}" dn 2>/dev/null|grep ^dn:|sed 's/dn: //g'`
    [ -n "${DN}" ] && /usr/bin/ldapdelete -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W "${DN}"
  }
}

modify() {

  [ -r "${1}" ] && {

    /usr/bin/ldapmodify -x -H ${LDAP_WRITE_SERVER} -D ${WRITE_USER} -W -c -f "${1}"
  }
}
