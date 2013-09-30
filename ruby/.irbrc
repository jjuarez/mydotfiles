require 'rubygems'

begin
  require 'irbtools' if RUBY_DESCRIPTION !~ /MacRuby/ && RUBY_DESCRIPTION !~ /1.8.7/
  require 'terminal-notifier' if RUBY_DESCRIPTION !~ /MacRuby/ && RUBY_DESCRIPTION !~ /1.8.7/
rescue LoadError => e
end
