##
# Rakefile 
require "yaml"

Dir.glob("#{ENV['MYDORFILES']}/lib/tasks/*.rb").each { |t| require t }

##
# Pre-conditions
fail("Environment variable MYDOTFILES undefined") unless ENV['MYDOTFILES']

##
# Init task load the configuration
task :load do

  config = YAML.load_file(File.join(ENV['MYDOTFILES'], "config", "mydotfiles.yaml"))

  $dotfiles = config[:dotfiles]
  $brews    = config[:brews]
  $urls     = config[:urls]
end
