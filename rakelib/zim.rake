# frozen_string_literal: true

namespace :zim do
  task :setup => :load do
  end

  desc 'Installs zim'
  task :install => :setup do
    puts("Just take a look here: #{$config['urls']['zimfw']['install']}")
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Uninstalls zim'
  task :uninstall => :setup do
    puts("Just take a look here: #{$config['urls']['zimfw']['uninstall']}")
  rescue StandardError => e
    warn(e.message)
  end
end
