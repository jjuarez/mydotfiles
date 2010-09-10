require 'rubygems'
#require 'utility_belt'
require 'wirble'
require 'hirb'
require 'ap'

##
# Colorize my life...
Wirble.init
Wirble.colorize
Hirb::View.enable

##
# Alias...
alias q exit
alias pp ap

##
# Class methods sort...
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

##
# IRB Options
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:EVAL_HISTORY] = 200

# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')

  require 'logger'

  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
 #IRB.conf[:USE_READLINE] = true
  #
  # Display the RAILS ENV in the prompt
  # ie : [Development]>> 
  IRB.conf[:PROMPT][:CUSTOM] = {
    :PROMPT_N => "[#{ENV["RAILS_ENV"].capitalize}]>> ",
    :PROMPT_I => "[#{ENV["RAILS_ENV"].capitalize}]>> ",
    :PROMPT_S => nil,
    :PROMPT_C => "?> ",
    :RETURN => "=> %s\n"
  }
  # Set default prompt
  IRB.conf[:PROMPT_MODE] = :CUSTOM
end

# We can also define convenient methods (credits go to thoughtbot)
def me
  User.find_by_email("me@gmail.com")
end
