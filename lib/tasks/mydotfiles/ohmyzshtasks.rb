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
  task :custom_plugins =>:load do
    begin
      omzcpd = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins')

      $ohmyzsh_rcp.each do |p|

        system("git clone #{p[:repository]} #{omzcpd}/#{p[:name]}") unless File.directory?(omzcpd)
      end
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall oh-my-zsh"
  task :uninstall do
    begin
      omzd = File.join(ENV['HOME'], '.oh-my-zsh')

      FileUtils.rm_rf(omzd) if File.directory?(omzd)
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
