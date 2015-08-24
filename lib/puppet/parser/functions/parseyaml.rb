#
# parseyaml.rb
#

module Puppet::Parser::Functions
  newfunction(:parseyaml, :type => :rvalue, :arity => -2, :doc => <<-EOS
This function accepts YAML as a string and converts it into the correct
Puppet structure.

The optional second argument can be used to pass a default value that will
be returned if the parsing of YAML string have failed.
    EOS
  ) do |arguments|

    require 'yaml'

    data = YAML::load(arguments[0])
    data = arguments[1] unless data
    data
  end
end

# vim: set ts=2 sw=2 et :
