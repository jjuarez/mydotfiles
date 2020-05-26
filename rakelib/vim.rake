# frozen_string_literal: true

namespace :vim do
  task :setup do
    @vimrc              = File.join(ENV['HOME'], '.vimrc')
    @custom_vimrc       = File.join(ENV['DOTFILES'], 'editors', 'vim', '.vimrc')
    @vundle_dir         = File.join(ENV['HOME'], '.vim', 'bundle')
    @vundle_destination = File.join(@vundle_dir, 'Vundle.vim')
  end

  desc 'Install vim vundle'
  task :install => [:load, :setup] do
    puts('vimrc')
    FileUtils.ln_sf(@custom_vimrc, @vimrc) unless File.exist?(@vimrc)

    puts('vundle')
    unless File.directory?(@vundle_destination)
      FileUtils.mkdir_p(@vundle_dir) unless File.directory?(@vundle_dir)
      system("git clone #{$config['urls']['vundle']} #{@vundle_destination}")
    end
  rescue StandardError => e
    warn(e.message)
  end
end
