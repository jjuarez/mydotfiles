##
# Rakefile 
require 'yaml'

##
# Pre-conditions
unless ENV['MYDOTFILES']

  warn("* Environment variable MYDOTFILES undefined, setting #{Dir.pwd}") unless ENV['MYDOTFILES']
  ENV['MYDOTFILES']=Dir.pwd
end

Dir.glob(File.join(ENV['MYDOTFILES'], 'lib', 'tasks', "*.rake")).each { |tf| load tf }


##
# Init task load the configuration
task :load do

  config_file = File.join(ENV['MYDOTFILES'], "config", "mydotfiles.yaml")
  config      = YAML.load_file(config_file)

  $dotfiles = config[:dotfiles]
  $brews    = config[:brews]
  $casks    = config[:casks]
  $urls     = config[:urls]
  $rbenv    = config[:rbenv]
end
