namespace :homebrew do

  task :install_base => :load do
    begin
      system("[ -x /usr/local/bin/brew ] || /usr/bin/ruby -e $(curl -fsSL $urls[:homebrew])")
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Install brews"
  task :install =>:install_base do

    begin
      $brews.each { |b| system("brew install #{b}") }
    rescue Exception =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall brews"
  task :uninstall =>:load do

    begin
      $brews.each { |b| system("brew uninstall #{b}") }
    rescue Exception =>e
      $stderr.puts e.message
    end
  end
end
