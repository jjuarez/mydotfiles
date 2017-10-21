namespace :rbenv do

  desc "Delete rbenv"
  task :uninstall =>:load do

    begin
      puts "Uninstalling all rbenv stuff..."
      FileUtils.remove_dir("#{ENV['HOME']}/.rbenv")
      warn "Do not forget to delete the rbenv configuration from your ~/.zshrc config file"
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install rbenv and plugins"
  task :install =>:load do

    begin
      puts "Installing rbenv:"
      system("git clone #{$rbenv[:url]} ~/.rbenv")

      puts "Installing rbenv plugins..."
      $rbenv[:plugins].each { |p| system("git clone #{p[:git]} ~/.rbenv/plugins/#{p[:name]}") }

      puts "Setup the config in ~/.zshrc..."
      File.open("#{ENV['HOME']}/.zshrc", 'a+') do |file| 

        file.puts '# Setup for rbenv'
        file.puts 'export PATH=${HOME}/.rbenv/bin:${PATH}'
        file.puts 'eval "$(rbenv init -)"'
      end
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
