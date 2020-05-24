# frozen_string_literal: true

namespace :ssh do
  desc 'Deletes the ssh configurations'
  task :uninstall => :load do
    puts 'not implemented yet'
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Installs the ssh configurations'
  task :install => :load do
    puts 'not implemented yet'
  rescue StandardError => e
    warn(e.message)
  end
end
