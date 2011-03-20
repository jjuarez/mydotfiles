##
# Rakefile 
#
DOTFILES = [
  { :versioned_item=>"bash_profile",  :local_item=>".bashrc"       },
  { :versioned_item=>"bash_profile",  :local_item=>".bash_profile" },
  { :versioned_item=>"vim",           :local_item=>".vim"          },
  { :versioned_item=>"vim/vimrc",     :local_item=>".vimrc"        },
  { :versioned_item=>"vim/gvimrc",    :local_item=>".gvimrc"       },
  { :versioned_item=>"ruby/irbrc",    :local_item=>".irbrc"        },
  { :versioned_item=>"ruby/gemrc",    :local_item=>".gemrc"        },
  { :versioned_item=>"ruby/rvmrc",    :local_item=>".rvmrc"        },
  { :versioned_item=>"ssh/config",    :local_item=>".ssh/config"   },
  { :versioned_item=>"git/gitconfig", :local_item=>".gitconfig"    }
]

VIM_PLUGINS = [
  { :name=>"vim-rake",        :url=>"https://github.com/tpope/vim-rake.git",        :local_name=>"vim/bundle/rake"        },
  { :name=>"vim-rails",       :url=>"https://github.com/tpope/vim-rails.git",       :local_name=>"vim/bundle/rails"       },
  { :name=>"vim-ruby-runner", :url=>"https://github.com/henrik/vim-ruby-runner",    :local_name=>"vim/bundle/ruby-runner" },
  { :name=>"vim-endwise",     :url=>"https://github.com/tpope/vim-endwise.git",     :local_name=>"vim/bundle/endwise"     },
  { :name=>"vim-surround",    :url=>"https://github.com/tpope/vim-surround.git",    :local_name=>"vim/bundle/surround"    },
  { :name=>"vim-unimpaired",  :url=>"https://github.com/tpope/vim-unimpaired.git",  :local_name=>"vim/bundle/unimpaired"  },
  { :name=>"vim-fugitive",    :url=>"https://github.com/tpope/vim-fugitive.git",    :local_name=>"vim/bundle/fugitive"    },
  { :name=>"vim-haml",        :url=>"https://github.com/tpope/vim-haml.git",        :local_name=>"vim/bundle/haml"        },
  { :name=>"nerdtree",        :url=>"https://github.com/scrooloose/nerdtree.git",   :local_name=>"vim/bundle/nerdtree"    },
  { :name=>"snipmate",        :url=>"https://github.com/msanders/snipmate.vim.git", :local_name=>"vim/bundle/snipmate"    },
  { :name=>"syntastic",       :url=>"https://github.com/scrooloose/syntastic.git",  :local_name=>"vim/bundle/syntastic"   },
  { :name=>"supertab",        :url=>"https://github.com/ervandew/supertab.git",     :local_name=>"vim/bundle/supertab"    }
] 

desc "Install all my vim plugins"
task :install_vim_plugins do

  begin
    VIM_PLUGINS.each do |plugin|

      puts plugin[:name]
      system( "git submodule add #{plugin[:url]} #{plugin[:local_name]}" )
    end      
  rescue Exception => e
    $stderr.puts( e.message )
  end
end


desc "Update all my vim plugins"
task :update_vim_plugins do

  VIM_PLUGINS.each do |plugin|
    
    puts plugin[:local_name]
    system( "cd #{plugin[:local_name]} && git submodule init && git submodule update" )
  end
end


desc "Install all mydotfiles"
task :install_my_dot_files do

  begin
    require 'fileutils'

    MY_DOT_FILES=ENV['MYDOTFILES'] ? ENV['MYDOTFILES'] : `pwd`
    FileUtils.cd( ENV['HOME'])
    
    DOTFILES.each do |dotfile|
      
      FileUtils.ln_s( File.join( MY_DOT_FILES, dofile[:versioned_item] ), File.join( ENV['HOME'], dotfile[:local_item] ) )
    end
  rescue
    fail( "You need to install the FileUtils gem" )
  end
end