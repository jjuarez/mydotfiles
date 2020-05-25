# frozen_string_literal: true

require 'yaml'

unless ENV['DOTFILES']
  warn("* Environment variable DOTFILES undefined, setting it to: #{Dir.pwd}")
  ENV['DOTFILES'] = Dir.pwd
end

task :load do
  $config = YAML.load_file(File.join(ENV['DOTFILES'], 'config.yml'))
rescue StandardError => e
  warn(e.message)
end
