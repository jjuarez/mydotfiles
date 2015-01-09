##
# Make a VNC tunnel with the guest vm through gen01 host
function vnc_tunnel {

  local vnc_port=${1:-"5900"}
  local jump_host=${2:-"gen01.tuenti.int"}

  ssh -L ${vnc_port}:localhost:${vnc_port} ${jump_host}
}
