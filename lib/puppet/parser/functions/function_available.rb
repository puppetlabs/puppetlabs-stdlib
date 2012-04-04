#
# function_available.rb
#

module Puppet::Parser::Functions
  newfunction(:function_available, :type => :rvalue, :doc => <<-EOS
This function accepts a string as an argument, determines whether the
Puppet runtime has access to a function by that name, and returns a
boolean.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "function_available?(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    Puppet::Parser::Functions.function(arguments[0].to_sym)
  end
end

# vim: set ts=2 sw=2 et :
