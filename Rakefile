##
# Rakefile 
require "yaml"

Dir.glob("#{ENV['MYDOTFILES']}/lib/tasks/*.rb").each { |t| require t }

##
# Pre-conditions
fail("Environment variable MYDOTFILES undefined") unless ENV['MYDOTFILES']

##
# Init task load the configuration
task :load do

  config_file = File.join(ENV['MYDOTFILES'], "config", "mydotfiles.yaml")
  config      = YAML.load_file(config_file)

  $dotfiles = config[:dotfiles]
  $brews    = config[:brews]
  $urls     = config[:urls]
end
