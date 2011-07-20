##
# Rakefile 
#
DOTFILES = [
  # Shell
  { :name=>".bash_profile",
    :git_item=>"shell/bash_profile",  
    :local_item=>".bash_profile" },
  { :name=>".zshrc",
    :git_item=>"shell/zshrc",  
    :local_item=>".zshrc" },
  # Vim & MacVim
  { :name=>".vim",
    :git_item=>"vim",           
    :local_item=>".vim"          },
  { :name=>".vimrc",
    :git_item=>"vim/vimrc",     
    :local_item=>".vimrc"        },
  { :name=>".gvimrc",
    :git_item=>"vim/gvimrc",    
    :local_item=>".gvimrc"       },
  # Ruby stuff
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
  # Git stuff  
  { :name=>".gitconfig",
    :git_item=>"git/gitconfig", 
    :local_item=>".gitconfig"    }
]

VIM_PLUGINS = [
  { :name=>"Pathogen",    
    :url=>"https://github.com/tpope/vim-pathogen.git",    
    :local_name=>"vim/bundle/pathogen"    },
  { :name=>"Rake",        
    :url=>"https://github.com/tpope/vim-rake.git",        
    :local_name=>"vim/bundle/rake"        },
  { :name=>"Rails",       
    :url=>"https://github.com/tpope/vim-rails.git",       
    :local_name=>"vim/bundle/rails"       },
  { :name=>"Ruby runner", 
    :url=>"https://github.com/henrik/vim-ruby-runner",    
    :local_name=>"vim/bundle/ruby-runner" },
  { :name=>"ENDwise",     
    :url=>"https://github.com/tpope/vim-endwise.git",     
    :local_name=>"vim/bundle/endwise"     },
  { :name=>"Surround",    
    :url=>"https://github.com/tpope/vim-surround.git",    
    :local_name=>"vim/bundle/surround"    },
  { :name=>"Unimpaired",  
    :url=>"https://github.com/tpope/vim-unimpaired.git",  
    :local_name=>"vim/bundle/unimpaired"  },
  { :name=>"Fugitive",    
    :url=>"https://github.com/tpope/vim-fugitive.git",    
    :local_name=>"vim/bundle/fugitive"    },
  { :name=>"HAML",        
    :url=>"https://github.com/tpope/vim-haml.git",        
    :local_name=>"vim/bundle/haml"        },
  { :name=>"NERDTree",        
    :url=>"https://github.com/scrooloose/nerdtree.git",   
    :local_name=>"vim/bundle/nerdtree"    },
  { :name=>"SnipMate",        
    :url=>"https://github.com/msanders/snipmate.vim.git", 
    :local_name=>"vim/bundle/snipmate"    },
  { :name=>"Syntastic",       
    :url=>"https://github.com/scrooloose/syntastic.git",  
    :local_name=>"vim/bundle/syntastic"   },
  { :name=>"Supertab",        
    :url=>"https://github.com/ervandew/supertab.git",     
    :local_name=>"vim/bundle/supertab"    },
  { :name=>"Tabular",        
    :url=>"https://github.com/godlygeek/tabular.git",
    :local_name=>"vim/bundle/tabular"    },
  { :name=>"RbRepl",        
    :url=>"https://github.com/Bogdanp/rbrepl.vim.git",
    :local_name=>"vim/bundle/rbrepl"    }
] 

##
# Vim tasks
#
namespace :vim do
  namespace :plugins do

    desc "Install all my vim plugins"
    task :install do

      begin
        puts "Installing vim plugins:"
        VIM_PLUGINS.each do |plugin|

          unless( File.exist?( plugin[:local_name] ) )
          
            puts "  downloading #{plugin[:name]} from #{plugin[:url]}"
            system( "git submodule add #{plugin[:url]} #{plugin[:local_name]}" )
          end
        end
      rescue Exception => e
        $stderr.puts( e.message )
      end
    end

    desc "Update all vim plugins"
    task :update do
    
      begin
        puts "Updating vim plugins:"
        VIM_PLUGINS.each do |plugin|
  
          if( File.exist?( plugin[:local_name] ) && File.directory?( plugin[:local_name] ) )
          
            puts "  #{plugin[:name]}"

            system( "git submodule init && git submodule update #{plugin[:local_name]}" )
          end
        end
        
        autoload_vim_directory = File.join( ENV['HOME'], %w[.vim autoload] )
        patogen_plugin         = File.join( ENV['MYDOTFILES'], %w[vim bundle pathogen autoload pathogen.vim] )
        
        FileUtils.mkdir_p( autoload_vim_directory ) unless File.exist?( autoload_vim_directory )
        FileUtils.cp( patogen_plugin, autoload_vim_directory )
      rescue Exception=>e
        $stderr.puts( e.message )
      end
    end
  end
end


##
# Dots Files tasks
#
namespace :dotfiles do

  desc "Delete the dotfiles links..."
  task :uninstall do

    begin
      puts "Uninstalling:"
      DOTFILES.each do |df| 
        
        local_file = File.join( ENV['HOME'], df[:local_item] )
        
        if( File.symlink?( local_file ) && df[:local_item] != ".vim" )
        
          puts "  #{df[:name]} in #{local_file}"
          FileUtils.rm_f( local_file )
        end
      end
      
      # vim base...
      FileUtils.rm_f( File.join( ENV['HOME'], ".vim" ) )

      %x(gem uninstall ldap-shell-utils)
    rescue Exception=>e
      $sdterr.puts( e.message )
    end
  end


  desc "Install mydotfiles"
  task :install do

    begin
      fail( "MYDOTFILES environment variable is not defined" ) unless ENV['MYDOTFILES']
      FileUtils.cd( ENV['HOME'] )
    
      puts "Installing:"
      
      %x(gem install ldap-shell-utils)
      
      DOTFILES.each do |df|
        
        gi = File.join( ENV['MYDOTFILES'], df[:git_item] )
        li = File.join( ENV['HOME'], df[:local_item] )
        
        if( File.exist?( gi ) ) 
        
          puts "  #{df[:name]} linking #{li} to #{gi}"
          FileUtils.ln_sf( gi, li ) 
        end                 
      end
    rescue Exception => e
      $stderr.puts( e.message )
    end
  end  
end
