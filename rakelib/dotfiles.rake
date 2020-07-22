# frozen_string_literal: true

namespace :dotfiles do
  desc 'Delete the dotfiles links'
  task :uninstall => :load do
    $config['dotfiles'].each do |df|
      local_file = File.join(ENV['HOME'], File.basename(df))

      puts " 💣 #{local_file}"
      FileUtils.rm_f(local_file)
    end
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Install mydotfiles'
  task :install => :load do
    $config['dotfiles'].each do |df|
      gi = File.join(ENV['DOTFILES'], df)
      li = File.join(ENV['HOME'], File.basename(df))

      if File.exist?(gi) && !File.exist?(li)
        puts " ✅ #{li} -> #{gi}"
        FileUtils.ln_sf(gi, li)
      end
    end
  rescue StandardError => e
    warn(e.message)
  end
end
