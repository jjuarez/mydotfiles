# frozen_string_literal: true

namespace :vim do
  task :setup do
    @vimrc              = File.join(ENV['HOME'], '.vimrc')
    @local_vimrc        = File.join(ENV['HOME'], '.vimrc.local')
    @custom_vimrc       = File.join(ENV['DOTFILES'], 'editors', 'vim', '.vimrc')
    @custom_local_vimrc = File.join(ENV['DOTFILES'], 'editors', 'vim', '.vimrc.local')
    @plug_dir           = File.join(ENV['HOME'], '.vim', 'autoload', 'plug.vim')
    @plug_plugins_dir   = File.join(ENV['HOME'], '.vim', 'plugged')
  end

  desc 'Deletes vim plug'
  task :uninstall => %i[load setup] do
    puts ' ⚠️  uninstalling plug'
    FileUtils.rm(@plug_dir, force: true) if File.exist?(@plug_dir)
    puts ' ⚠️  uninstalling all the plug plugins'
    FileUtils.rm_r(@plug_plugins_dir, force: true) if File.exist?(@plug_plugins_dir)
  rescue StandardError => e
    warn(e.message)
  end

  desc 'Installs vim plug'
  task :install => %i[load setup] do
    puts ' ✅ seting up the custom .vimrc file'
    FileUtils.ln_sf(@custom_vimrc, @vimrc) unless File.exist?(@vimrc)

    puts ' ✅ seting up the custom .vimrc.local file'
    FileUtils.ln_sf(@custom_local_vimrc, @local_vimrc) unless File.exist?(@local_vimrc)

    unless File.directory?(@plug_dir)
      puts ' ✅ installing plug'
      system("curl -sfLo #{@plug_dir} --create-dirs #{$config['urls']['plug']}")
      puts ' to complete the installation of all your plugins: vim +PlugInstall'
    end
  rescue StandardError => e
    warn(e.message)
  end
end
