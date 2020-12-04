# node stuff
node::clean_node_modules() {
  find . -type d -name node_modules -exec rm -rv {} +
}

node::clean_dists() {
  find . -type d -name dist -exec rm -rv {} +
}

autoload node::clean_node_modules
autoload node::clean_dists

alias ncnm='node::clean_node_modules'
alias ncd='node::clean_dists'
