require 'rubygems'

begin
  require 'irbtools'
rescue LoadError => e
  $stderr.puts "Problemas cargado las gemas: #{e}"
end
