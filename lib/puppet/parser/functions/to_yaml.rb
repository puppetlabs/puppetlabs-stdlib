#
# to_yaml.rb
#

module Puppet::Parser::Functions
  newfunction(:to_yaml, :type => :rvalue, :doc => <<-EOS
This function accepts a puppet data structure (I.E hash/array/string or nested combination of these) and converts it into a yaml format string, so that YAML files can be written using the content param in the file provider.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "to_yaml(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    ZAML.dump(arguments[0])

  end
end

# vim: set ts=2 sw=2 et :
