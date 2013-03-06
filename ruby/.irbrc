require 'rubygems'

begin
  require 'irbtools' if RUBY_DESCRIPTION !~ /MacRuby/ && RUBY_DESCRIPTION !~ /1.8.7/
  require 'terminar-notifier' if RUBY_DESCRIPTION !~ /MacRuby/ && RUBY_DESCRIPTION !~ /1.8.7/
  
rescue LoadError => e
  $stderr.puts "ERROR: #{e.message}"
end
