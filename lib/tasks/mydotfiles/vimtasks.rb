namespace :vim do
  namespace :vundle do

    desc "Install vim vundle"
    task :install do

      vd = File.join(ENV['HOME'], '.vim', 'bundle')

      unless File.directory?(vd)

        FileUtils.mkdir_p(vd)
        system("git clone #{$urls[:vundle]} #{File.join(vd, 'vundle')}")
      end
    end
  end
end
