# frozen_string_literal: true

require 'yaml'

task :load do
  $config = YAML.load_file(File.join(ENV['DOTFILES'], 'config.yml'))
rescue StandardError => e
  warn(e.message)
end
