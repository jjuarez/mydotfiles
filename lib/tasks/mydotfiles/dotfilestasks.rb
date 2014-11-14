namespace :dotfiles do

  desc "Delete the dotfiles links"
  task :uninstall do

    begin
      puts "Uninstalling:"

       $dotfiles.each do |df|

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
      FileUtils.cd(ENV['HOME'])

      puts "Installing:"

      $dotfiles.each do |df|

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
