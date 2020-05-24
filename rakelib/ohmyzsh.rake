# frozen_string_literal: true

namespace :ohmyzsh do
  desc 'Install oh-my-zsh'
  task :install => :load do
    omzd = File.join(ENV['HOME'], '.oh-my-zsh')
    system("git clone #{$urls[:ohmyzsh]} #{omzd}") unless File.directory?(omzd)
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Install oh-my-zsh custom plugins'
  task :plugins => :load do
    lpd    = File.join(ENV['MYDOTFILES'], 'tools', 'zsh', 'oh-my-zsh', 'plugins')
    omzcpd = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins')

    Dir.glob("#{lpd}/**/*.plugin.zsh").each do |pf|
      pd  = File.dirname(pf).split(File::SEPARATOR).last
      apd = File.join(omzcpd, pd)

      Dir.mkdir(apd) unless File.exist?(apd)
      FileUtils.cp(pf, apd)
    end
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Uninstall oh-my-zsh'
  task :uninstall do
    omzd = File.join(ENV['HOME'], '.oh-my-zsh')
    FileUtils.rm_rf(omzd) if File.directory?(omzd)
  rescue StandardError => e
    warn(e.message)
  end
end
