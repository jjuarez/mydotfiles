# frozen_string_literal: true

namespace :vim do
  namespace :vundle do
    desc 'Install vim vundle'
    task :install => :load do
      vundle_directory   = File.join(ENV['HOME'], '.vim', 'bundle')
      vundle_destination = File.join(vundle_directory, 'Vundle.vim')

      unless File.directory?(vundle_destination)
        FileUtils.mkdir_p(vundle_directory) unless File.directory?(vundle_directory)
        system("git clone #{$urls[:vundle]} #{File.join(vundle_directory, 'Vundle.vim')}")
      end
    rescue StandardEror => e
      warn(e.message)
    end
  end
end
