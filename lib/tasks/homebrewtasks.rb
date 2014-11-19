namespace :homebrew do

  desc "Install brews"
  task :install =>:load do

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
