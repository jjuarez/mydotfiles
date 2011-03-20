
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

task :default=>[:install_vim_plugins]

