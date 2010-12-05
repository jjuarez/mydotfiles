begin
  require 'rubygems'
  require 'wirble'
  
  Wirble.init
  Wirble.colorize
rescue LoadError => e
end