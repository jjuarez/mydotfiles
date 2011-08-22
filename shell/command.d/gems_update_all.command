gems_update_all() {

  [ -d "${HOME}/.rvm" ] && {

    RUBIES=${${1}:-"rbx ree 1.8 1.9"}

    for r in `echo ${RUBIES}`; do
      rvm use ${r} && gem update
    done
  }
}
