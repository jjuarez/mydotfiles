require 'rubygems'

begin
 require 'irbtools'
rescue LoadError => e
  $stderr.puts "irbtools not found"
end
