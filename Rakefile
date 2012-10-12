##
# Rakefile 
#
DOTFILES = [
  ##
  # Shell config
  #
  { :name=>".bash_profile",
    :git_item=>"shell/bash_profile",  
    :local_item=>".bash_profile" },
  { :name=>".zshrc",
    :git_item=>"shell/zshrc",  
    :local_item=>".zshrc" },
  { :name=>"thejtoken.zsh-theme",
    :git_item=>"shell/zsh/themes/thejtoken.zsh-theme",  
    :local_item=>".oh-my-zsh/themes/thejtoken.zsh-theme" },
  ##
  # Ruby stuff
  #
  { :name=>".irbrc",
    :git_item=>"ruby/irbrc",    
    :local_item=>".irbrc"        },
  { :name=>".gemrc",
    :git_item=>"ruby/gemrc",    
    :local_item=>".gemrc"        },
  { :name=>".rvmrc",
    :git_item=>"ruby/rvmrc",    
    :local_item=>".rvmrc"        },
  { :name=>".ssh/config",
    :git_item=>"ssh/config",    
    :local_item=>".ssh/config"   },
  ##
  # Git stuff
  #  
  { :name=>".gitconfig",
    :git_item=>"git/gitconfig", 
    :local_item=>".gitconfig"    }
]

GEM_LIST = []


##
# Dots Files tasks
#
namespace :dotfiles do
  desc "Delete the dotfiles links"
  task :uninstall do

    begin
      puts("Uninstalling:")
      
      DOTFILES.each do |df| 
        
        local_file = File.join(ENV['HOME'], df[:local_item])
        
        if(File.symlink?(local_file) && df[:local_item] != ".vim")
        
          puts("* #{df[:name]} in #{local_file}")
          FileUtils.rm_f(local_file)
        end
      end
      
      FileUtils.rm(File.join(ENV['HOME'], ".vim"))
    rescue =>e
      $sdterr.puts(e.message)
    end
  end


  desc "Install mydotfiles"
  task :install do

    begin
      fail("MYDOTFILES environment variable is not defined") unless ENV['MYDOTFILES']
      FileUtils.cd(ENV['HOME'])

      puts("Installing:")      

      DOTFILES.each do |df|

        gi = File.join(ENV['MYDOTFILES'], df[:git_item])
        li = File.join(ENV['HOME'], df[:local_item])

        if(File.exist?(gi)) 

          puts("* #{df[:name]} linking #{li} to #{gi}")
          FileUtils.ln_sf(gi, li) 
        end
      end
    rescue=>e
      $stderr.puts(e.message)
    end
  end
end


##
# Gem environment
#
namespace :gems do
  
  desc "Install personal gemsets over actual ruby@global"
  task :install do

    GEM_LIST.each { |g| system("gem install --no-rdoc --no-ri #{g}") }
  end  

  desc "Uninstall personal gemsets"
  task :uninstall do

    GEM_LIST.each { |g| system("gem uninstall -ax #{g}") }
  end  
end
