namespace :ohmyzsh do
  desc 'Install oh-my-zsh'
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
      lpd    = File.join(ENV['MYDOTFILES'], 'shell', 'zsh', 'plugins')
      omzcpd = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins')

      Dir.glob("#{lpd}/**/*.plugin.zsh").each do |pf|
        pd  = File.dirname(pf).split(File::SEPARATOR).last
        apd = File.join(omzcpd, pd)

        Dir.mkdir(apd) unless File.exist?(apd)
        FileUtils.cp(pf, apd)
      end
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc 'Uninstall oh-my-zsh'
  task :uninstall do
    begin
      omzd = File.join(ENV['HOME'], '.oh-my-zsh')

      FileUtils.rm_rf(omzd) if File.directory?(omzd)
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
