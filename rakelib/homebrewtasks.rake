namespace :homebrew do
  namespace :formula do
    desc "Install formulas"
    task :install =>:load do
      begin
        $formulas.each { |f| system("[ -x /usr/local/bin/brew ] && /usr/local/bin/brew install #{f}") }
      rescue Exception =>e
        $stderr.puts e.message
      end
    end

    desc "Uninstall formulas"
    task :uninstall =>:load do
      begin
        $formulas.each { |f| system("[ -x /usr/local/bin/brew ] && /usr/local/bin/brew uninstall --force #{f}") }
      rescue Exception =>e
        $stderr.puts e.message
      end
    end
  end

  namespace :cask do
    task :tap => :load do
      begin
        system("[ -x /usr/local/bin/brew ] && /usr/local/bin/brew tap caskroom/cask")
      rescue Exception =>e
        $stderr.puts e.message
      end
    end

    desc "Install casks"
    task :install =>:tap do
      begin
        $casks.each { |c| system("[ -x /usr/local/bin/brew ] && /usr/local/bin/brew cask install #{c}") }
      rescue Exception =>e
        $stderr.puts e.message
      end
    end

    desc "Uninstall casks"
    task :uninstall =>:tap do
      begin
        $casks.each { |c| system("[ -x /usr/local/bin/brew ] || /usr/local/bin/brew cask uninstall --force #{c}") }
      rescue Exception =>e
        $stderr.puts e.message
      end
    end
  end
end
