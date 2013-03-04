# vim:ft=sh
function generate_project() {

  [ -d "${1}" ] && {

    echo "The directory: ${1} already exist"
    exit 1
  }

  local project="${1}"
  mkdir -p "${project}/"{bin,lib,test,config}

  cat>"${project}/.rvmrc"<<EOF
# Warning! You need to define this ruby alias i.e:
# rvm alias create 1.9 ruby-1.9.3-p392
rvm use 1.9@${1} --create
EOF

  cat>"${project}/Gemfile"<<EOF
source 'https://rubygems.org/'

#gem 'foo'

group :development do

  gem 'bundler'
  gem 'rake'
  gem 'rdoc'
  gem 'irbtools'
  gem 'terminal-notifier'
end
EOF

  cd "${project}"
  bundle install
}
