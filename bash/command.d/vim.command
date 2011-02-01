##
# Vim plugin update (pathogen)
#
update_vim_plugins() {

  cd ${MYDOTFILES} &>/dev/null

  for plugin in `ls -1 vim/bundle`; do

    git submodule update vim/bundle/${plugin}
  done

  cd - &>/dev/null
}
