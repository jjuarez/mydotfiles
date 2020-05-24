# frozen_string_literal: true

namespace :dotfiles do
  desc 'Delete the dotfiles links'
  task :uninstall => :load do
    $dotfiles.each do |df|
      local_file = File.join(ENV['HOME'], File.basename(df))

      if File.symlink?(local_file) && local_file != '.vim'
        puts " - #{local_file}"
        FileUtils.rm_f(local_file)
      end
    end
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Install mydotfiles'
  task :install => :load do
    $dotfiles.each do |df|
      gi = File.join(ENV['MYDOTFILES'], df)
      li = File.join(ENV['HOME'], File.basename(df))

      if File.exist?(gi) && !File.exist?(li)
        puts " √ #{li} -> #{gi}"
        FileUtils.ln_sf(gi, li)
      end
    end
  rescue StandardError => e
    warn(e.message)
  end
end
