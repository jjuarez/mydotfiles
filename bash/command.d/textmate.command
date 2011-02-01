update_textmate_plugins() {

  cd "${HOME}/Library/Application Support/TextMate/Bundles" &>/dev/null
  svn --quiet update
  cd - &>/dev/null
}
