namespace :cask do

  task :tap => :load do
    begin
      system("brew tap caskroom/cask")
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install brews"
  task :install =>:tap do

    begin
      $casks.each { |b| system("brew cask install #{b}") }
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall brews"
  task :uninstall =>:tap do

    begin
      $casks.each { |b| system("brew cask uninstall #{b}") }
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
