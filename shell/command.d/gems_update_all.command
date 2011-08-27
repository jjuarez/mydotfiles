gems_update_all() {

  [ -d "${HOME}/.rvm" ] && {

    RUBIES=${${1}:-"rbx ree 1.8 1.9 macruby jruby"}

    for rvm in `echo ${RUBIES}`; do

      rvm use ${rvm} && gem update 

      case ${rvm} in
        jruby)
          sleep 5
          gem update --system
        ;;

        macruby)
        ;;        

        *)  
          gem update --system
        ;;
      esac 
    done
  }
}
