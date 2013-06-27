##
# Rakefile 
DOTFILES = [
  # Shell config
  { :name       =>".vimrc",
    :git_item   =>"vim/.vimrc",  
    :local_item =>".vimrc" 
  },
  { :name       =>".zprofile",
    :git_item   =>"shell/.zprofile",  
    :local_item =>".zprofile" 
  },
  { :name       =>".zshrc",
    :git_item   =>"shell/.zshrc",  
    :local_item =>".zshrc" 
  },
  { :name       =>"thejtoken.zsh-theme",
    :git_item   =>"shell/zsh/themes/thejtoken.zsh-theme",  
    :local_item =>".oh-my-zsh/themes/thejtoken.zsh-theme" 
  },
  { :name       =>".ssh/config",
    :git_item   =>"ssh/config",    
    :local_item =>".ssh/config" 
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
  { :name       =>".rvmrc",
    :git_item   =>"ruby/.rvmrc",    
    :local_item =>".rvmrc"        
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

GEM_LIST = ["irbtools"]

namespace :vim do
  
  desc "Install vim vundle"
  task :vundle do
 
    vundle_directory = File.join(ENV['HOME'], '.vim', 'bundle')

    unless File.directory?(vundle_directory)
       
      FileUtils.mkdir_p(vundle_directory)
      system("git clone https://github.com/gmarik/vundle.git #{File.join(vundle_directory, 'vundle')}")
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
        
        if(File.symlink?(local_file) && df[:local_item] != ".vim")
        
          puts "* #{df[:name]} in #{local_file}"
          FileUtils.rm_f(local_file)
        end
      end
      
      FileUtils.rm(File.join(ENV['HOME'], ".vim"))
    rescue =>e
      puts e.message
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

        if(File.exist?(gi)) 

          puts "* #{df[:name]} linking #{li} to #{gi}"
          FileUtils.ln_sf(gi, li) 
        end
      end
    rescue =>e
      puts e.message
    end
  end
end

namespace :gems do
  
  desc "Install personal gemsets over actual rvm environment ruby@global"
  task :install do

    GEM_LIST.each { |gem| system("gem install --no-rdoc --no-ri #{gem}") }
  end  

  desc "Uninstall personal gemsets"
  task :uninstall do

    GEM_LIST.each { |gem| system("gem uninstall -ax #{gem}") }
  end  
end
