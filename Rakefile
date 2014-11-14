##
# Rakefile 
$:.push File.expand_path("../lib/tasks", __FILE__)
require "yaml"
require "mydotfiles/vimtasks"
require "mydotfiles/ohmyzshtasks"
require "mydotfiles/dotfilestasks"


##
# Pre-conditions
fail("Environment variable MYDOTFILES undefined") unless ENV['MYDOTFILES']


##
# Global variables for the configuration
$config_file = File.join(ENV['MYDOTFILES'], "mydotfiles.yaml")
$config = YAML.load_file($config_file)
$dotfiles = $config[:dotfiles]
$ohmyzsh_remote_custom_plugins = $config[:ohmyzsh_remote_custom_plugins]
$urls = $config[:urls]
