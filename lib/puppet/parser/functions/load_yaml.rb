#
# load_yaml.rb
#

module Puppet::Parser::Functions
  newfunction(:load_yaml, :type => :rvalue, :doc => <<-EOS
This function accepts YAML as a string and converts it into the correct 
Puppet structure.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "load_yaml(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    require 'yaml'

    YAML::load(arguments[0])

  end
end

# vim: set ts=2 sw=2 et :
