##
# Rakefile 
DOTFILES = [
  # vim config
  { :name       =>".vimrc",
    :git_item   =>"vim/.vimrc",  
    :local_item =>".vimrc" 
  },
  # Shell config
  { :name       =>".zprofile",
    :git_item   =>"shell/.zprofile",  
    :local_item =>".zprofile" 
  },
  { :name       =>".zshrc",
    :git_item   =>"shell/.zshrc",  
    :local_item =>".zshrc" 
  },
  { :name       =>".zlogin",
    :git_item   =>"shell/.zlogin",  
    :local_item =>".zlogin" 
  },
  { :name       =>".ssh/config",
    :git_item   =>"ssh/config",    
    :local_item =>".ssh/config" 
  },
  # ZSH theme
  { :name       =>".oh-my-zsh/themes/thejtoken.zsh-theme",
    :git_item   =>"shell/zsh/themes/thejtoken.zsh-theme",    
    :local_item =>".oh-my-zsh/themes/thejtoken.zsh-theme" 
  },
  # Ruby stuff
  { :name       =>".irbrc",
    :git_item   =>"ruby/.irbrc",    
    :local_item =>".irbrc"        
  },
  { :name       =>".gemrc",
    :git_item   =>"ruby/.gemrc",    
    :local_item =>".gemrc"        
  },
  # Git stuff
  { :name       =>".gitconfig",
    :git_item   =>"git/.gitconfig", 
    :local_item =>".gitconfig"    
  },
  { :name       =>".gitignore_global",
    :git_item   =>"git/.gitignore_global", 
    :local_item =>".gitignore_global"    
  }
]

OHMYZSH_CUSTOM_PLUGINS=[
  {
    :name       => "oh-my-zsh-bootstrap",
    :repository => "git://github.com/mbauhardt/oh-my-zsh-bootstrap.git"
  }
]


namespace :vim do
  namespace :vundle do
  
    desc "Install vim vundle"
    task :install do
 
      vundle_directory = File.join(ENV['HOME'], '.vim', 'bundle')

      unless File.directory?(vundle_directory)
       
        FileUtils.mkdir_p(vundle_directory)
        system("git clone https://github.com/gmarik/vundle.git #{File.join(vundle_directory, 'vundle')}")
      end
    end
  end
end


namespace :rvm do

  desc "Install rvm"
  task :install do
    begin
      rvm_directory = File.join(ENV['HOME'], '.rvm') 

      system("curl -sL https://get.rvm.io|bash") unless File.directory?(rvm_directory)
    rescue =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall rvm"
  task :uninstall do
    begin
      rvm_directory = File.join(ENV['HOME'], '.rvm')

      system("rvm uninstall")  
    rescue =>e
      $stderr.puts e.message
    end
  end
end


namespace :ohmyzsh do

  desc "Install oh-my-zsh"
  task :install do
    begin
      oh_my_zsh_directory = File.join(ENV['HOME'], '.oh-my-zsh')

      system("git clone https://github.com/robbyrussell/oh-my-zsh.git #{oh_my_zsh_directory}") unless File.directory?(oh_my_zsh_directory)
    rescue =>e
      $stderr.puts e.message
    end
  end

  desc "Install oh-my-zsh custom plugins"
  task :custom_plugins do
    begin
      oh_my_zsh_custom_plugins_directory = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins')

      OHMYZSH_CUSTOM_PLUGINS.each do |plugin|
      
        system("git clone #{plugin[:repository]} #{oh_my_zsh_custom_plugins_directory}/custom/plugins/#{plugin[:name]}") unless File.directory?(oh_my_zsh_custom_plugins_directory)
      end
    rescue =>e
      $stderr.puts e.message
    end
  end

  desc "Uninstall oh-my-zsh"
  task :uninstall do
    begin
      oh_my_zsh_directory = File.join(ENV['HOME'], '.oh-my-zsh')

      FileUtils.rm_rf(oh_my_zsh_directory) if File.directory?(oh_my_zsh_directory)
    rescue =>e
      $stderr.puts e.message
    end
  end
end


namespace :dotfiles do
 
  desc "Delete the dotfiles links"
  task :uninstall do

    begin
      puts "Uninstalling:"
      
      DOTFILES.each do |df| 
        
        local_file = File.join(ENV['HOME'], df[:local_item])
        
        if File.symlink?(local_file) && df[:local_item] != ".vim"
        
          puts "* #{df[:name]} in #{local_file}"
          FileUtils.rm_f(local_file)
        end
      end
      
      FileUtils.rm(File.join(ENV['HOME'], ".vim"))
    rescue =>e
      $stderr.puts e.message
    end
  end

  desc "Install mydotfiles"
  task :install do

    begin
      fail("MYDOTFILES environment variable is not defined") unless ENV['MYDOTFILES']
      FileUtils.cd(ENV['HOME'])

      puts "Installing:"

      DOTFILES.each do |df|

        gi = File.join(ENV['MYDOTFILES'], df[:git_item])
        li = File.join(ENV['HOME'], df[:local_item])

        if File.exist?(gi) 

          puts "* #{df[:name]} linking #{li} to #{gi}"
          FileUtils.ln_sf(gi, li) 
        end
      end
    rescue =>e
      $stderr.puts e.message
    end
  end
end
