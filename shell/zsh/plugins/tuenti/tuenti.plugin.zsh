##
# Make a VNC tunnel with the guest vm through gen01 host
vnc_tunnel() {

  local vnc_base_port=5900
  local vm_host=${1:-"vm1"}
  local vm_domain=${2:-"1"}
  local jump_host="gen01.tuenti.int"

  let "vnc_port=${vnc_base_port}+${vm_domain}"
  ssh -L ${vnc_port}:"${vm_host}.tuenti.int":${vnc_port} ${jump_host}
}


##
# make a SSH tunnet with the KVM DC
kvm_tunnel() {

  local kvm_instance=${1}
  local kvm_base_port=15440
  local kvm_remote_port=15443
  local jump_host="gen01.tuenti.int"
  local jump_user="root"

  case ${kvm_instance} in
    1|2|3)
      let "kvm_port=${kvm_base_port}+${kvm_instance}"
      kvm_host="kvm${kvm_instance}"
      ssh -L ${kvm_port}:"${kvm_host}.tuenti.mgm":${kvm_remote_port} "${jump_user}@${jump_host}"
    ;;
  esac
}


##
# Check if we have some CDR spool
any_spools() {

  for trans_server in $(cat /srv/config/mvnetrans_prod_server_list 2>/dev/null); do

    ssh root@${trans_server} '[ -s /var/log/freeswitch/cdr-spool.sql ] && echo "$(hostname) has spool"'
  done
}


##
## Function to consume fabolous tuenti lists of hosts
load_list() {

  local list_file=${1}

  [ -s ${list_file} ] && grep -Ev "^(\s*)#" ${list_file}
}
