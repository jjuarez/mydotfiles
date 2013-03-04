# vim:ft=sh
function generate_project() {

  [ -d "${1}" ] && {

    echo "The directory: ${1} already exist"
    exit 1
  }

  local project="${1}"
  mkdir -p "${project}/"{bin,lib,test,config}

  # Generate .rvm file
  cat>"${project}/.rvmrc"<<EOF
# Warning! You need to define this ruby alias i.e:
# rvm alias create 1.9 ruby-1.9.3-p392
rvm use 1.9@${1} --create
EOF

  # Generate Gemfile for project dependencies
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

  # Generate a basic Rakefile
  cat>"${project}/Rakefile"<<EOF
require 'rubygems'

##
# An example of task
desc "This is a simple task"
task :simple do

  puts "Yeah!, this si a very simple task"
end
EOF

  # Startup the project skell
  cd "${project}"
  bundle install
}
