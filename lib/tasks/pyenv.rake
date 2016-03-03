namespace :pyenv do

  desc "Delete pyenv"
  task :uninstall =>:load do

    begin
      puts "Uninstalling all pyenv stuff..."
      FileUtils.remove_dir("#{ENV['HOME']}/.pyenv")
      warn "Do not forget to delete the pyenv configuration from your ~/.zshrc config file"
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install pyenv and plugins"
  task :install =>:load do

    begin
      puts "Installing pyenv:"
      system("git clone #{$pyenv[:url]} ~/.pyenv")

      puts "Installing pyenv plugins..."
      $pyenv[:plugins].each { |p| system("git clone #{p[:git]} ~/.pyenv/plugins/#{p[:name]}") }

      puts "Setup the config in ~/.zshrc..."
      File.open("#{ENV['HOME']}/.zshrc", 'a+') do |file| 

        file.puts '# Setup for pyenv'
        file.puts 'export PATH=${HOME}/.pyenv/bin:${PATH}'
        file.puts 'eval "$(pyenv init -)"'
        file.puts 'eval "$(pyenv virtualenv-init -)"'
      end
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
