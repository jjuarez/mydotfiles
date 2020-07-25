# frozen_string_literal: true

namespace :brew do
  desc 'Delete the brews, taps, casks, and mas'
  task :uninstall => :load do
    puts "Just take a look here: #{$config['urls']['homebrew']['uninstall']}"
  rescue StandarError => e
    warn(e.message)
  end

  desc 'Install brews, taps, casks, and mas'
  task :install => :load do
    brew_file = File.join(ENV['MYDOTFILES'], 'tools', 'brew', 'Brewfile')

    if File.exist?(brew_file)
      puts "Installing from: #{brew_file}"
      system("brew bundle --file #{brew_file}")
    end
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Backup brews, taps, casks, and mas'
  task :dump => :load do
    brew_file = File.join(ENV['MYDOTFILES'], 'tools', 'brew', 'Brewfile')

    if File.exist?(brew_file)
      puts "Dumping brews to: #{brew_file}"
      system("brew bundle dump --force --file #{brew_file}")
    end
  rescue StandardError => e
    warn(e.message)
  end
end
