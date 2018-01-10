namespace :ohmyzsh do

  desc "Install oh-my-zsh"
  task :install =>:load do
    begin
      omzd = File.join(ENV['HOME'], '.oh-my-zsh')

      system("git clone #{$urls[:ohmyzsh]} #{omzd}") unless File.directory?(omzd)
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install oh-my-zsh custom plugins"
  task :plugins =>:load do
    begin
      lpd    = File.join(ENV['MYDOTFILES'], "shell", "zsh", "plugins")
      omzcpd = File.join(ENV['HOME'], ".oh-my-zsh", "custom")

      FileUtils.cp_r(lpd, omzcpd, :verbose =>false)
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall oh-my-zsh"
  task :uninstall do
    begin
      omzd = File.join(ENV['HOME'], ".oh-my-zsh")

      FileUtils.rm_rf(omzd) if File.directory?(omzd)
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
