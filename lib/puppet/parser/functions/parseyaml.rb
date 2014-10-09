#
# parseyaml.rb
#

module Puppet::Parser::Functions
  newfunction(:parseyaml, :type => :rvalue, :arity => 1, :doc => <<-EOS
This function accepts YAML as a string and converts it into the correct
Puppet structure.
    EOS
  ) do |arguments|

    require 'yaml'

    YAML::load(arguments[0])

  end
end

# vim: set ts=2 sw=2 et :
