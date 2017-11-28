#!/usr/bin/env ruby

require 'irb/completion'
require 'irb/ext/save-history'

%w{wirble awesome_print}.each do |gem|
  begin
    require gem
  rescue LoadError =>le
    warn("Can't load gem: #{gem} (#{le.message})")
  end
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE]  = :SIMPLE



class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

