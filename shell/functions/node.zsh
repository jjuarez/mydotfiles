node::clean_node_modules() {
  find . -maxdepth 3 -type d -name node_modules -exec rm -rv {} +
}

node::clean_dists() {
  find . -maxdepth 3 -type d -name dist -exec rm -rv {} +
}


node::clean_all() {
  node::clean_node_modules
  node::clean_dists
}

# autoloads
autoload node::clean_node_modules
autoload node::clean_dists
autoload node::clean_all

# aliases

