##
# Rakefile 
require "yaml"

##
# Pre-conditions
fail("Environment variable MYDOTFILES undefined") unless ENV['MYDOTFILES']

Dir.glob(File.join(ENV['MYDOTFILES'], 'lib', 'tasks', "*.rake")).each { |tf| load tf }


##
# Init task load the configuration
task :load do

  config_file = File.join(ENV['MYDOTFILES'], "config", "mydotfiles.yaml")
  config      = YAML.load_file(config_file)

  $dotfiles = config[:dotfiles]
  $brews    = config[:brews]
  $urls     = config[:urls]
end
