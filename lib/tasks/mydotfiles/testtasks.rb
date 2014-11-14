namespace :tests do
  task :config =>:load do

    puts $config.inspect
  end
end
