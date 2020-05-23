##
# Rakefile 
require 'yaml'

##
# Pre-conditions
unless ENV['MYDOTFILES']
  warn("* Environment variable MYDOTFILES undefined, setting it to: #{Dir.pwd}")
  ENV['MYDOTFILES']=Dir.pwd
end

##
# Init task load the configuration
task :load do
  config_file = File.join(ENV['MYDOTFILES'], "config", "mydotfiles.yaml")
  config      = YAML.load_file(config_file)

  $dotfiles = config['dotfiles']
  $urls     = config['urls']
end
