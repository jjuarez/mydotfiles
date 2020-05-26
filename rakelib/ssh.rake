# frozen_string_literal: true

namespace :ssh do
  desc 'Deletes the ssh configurations'
  task :uninstall => :load do
    ssh_config_file = File.join(ENV['HOME'], '.ssh', 'config')
    FileUtils.rm(ssh_config_file) if File.exist?(ssh_config_file)
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Installs the ssh configurations'
  task :install => :load do
    ssh_config_file        = File.join(ENV['HOME'], '.ssh', 'config')
    custom_ssh_config_file = File.join(ENV['DOTFILES'], 'tools', 'ssh', 'config')

    if File.exist?(custom_ssh_config_file) && !File.symlink?(ssh_config_file)
      puts " √ #{ssh_config_file} -> #{custom_ssh_config_file}"
      FileUtils.ln_sf(custom_ssh_config_file, ssh_config_file)
    end
  rescue StandardError => e
    warn(e.message)
  end
end
