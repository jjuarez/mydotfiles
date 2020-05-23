namespace :brew do
  desc 'Delete the brews, taps, casks, and mas'
  task :uninstall =>:load do
    begin
      puts 'Uninstalling (not implemented):'
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install brews, taps, casks, and mas"
  task :install =>:load do
    begin
      FileUtils.cd(ENV['HOME'])
      puts 'Installing:'

      gi = FileUtils.ln_sf(File.join(ENV['MYDOTFILES'], 'Brewfile'))
      li = FileUtils.ln_sf(File.join(ENV['HOME'], 'Brewfile'))

      unless File.exist?(gi)
        puts " √ Brewfile linking #{li} to #{gi}"
        FileUtils.ln_sf(gi, li)
      end
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
