# frozen_string_literal: true

namespace :vim do
  task :setup do
    @vimrc              = File.join(ENV['HOME'], '.vimrc')
    @local_vimrc        = File.join(ENV['HOME'], '.vimrc.local')
    @custom_vimrc       = File.join(ENV['DOTFILES'], 'editors', 'vim', '.vimrc')
    @custom_local_vimrc = File.join(ENV['DOTFILES'], 'editors', 'vim', '.vimrc.local')
    @vundle_dir         = File.join(ENV['HOME'], '.vim', 'bundle')
    @vundle_destination = File.join(@vundle_dir, 'Vundle.vim')
  end

  desc 'Deletes vim vundle'
  task :uninstall => %i[load setup] do
    puts(" 🔖 Please take a look here: #{$config['url']['vundle']}")
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Installs vim vundle'
  task :install => %i[load setup] do
    puts ' ✅ seting up the custom .vimrc file'
    FileUtils.ln_sf(@custom_vimrc, @vimrc) unless File.exist?(@vimrc)

    puts ' ✅ seting up the custom .vimrc.local file'
    FileUtils.ln_sf(@custom_local_vimrc, @local_vimrc) unless File.exist?(@local_vimrc)

    unless File.directory?(@vundle_destination)
      FileUtils.mkdir_p(@vundle_dir) unless File.directory?(@vundle_dir)
      puts ' ✅ cloning the Vundle git repository'
      system("git clone #{$config['urls']['vundle']} #{@vundle_destination}")
    end
  rescue StandardError => e
    warn(e.message)
  end
end
