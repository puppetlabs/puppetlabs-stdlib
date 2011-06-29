#
# delete.rb
#

# TODO(Krzysztof Wilczynski): We need to add support for regular expression ...
# TODO(Krzysztof Wilczynski): Support for strings and hashes too ...

module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "is_valid_netmask(): Wrong number of arguments "+
        "given #{arguments.size} for 2")
    end

  end
end

# vim: set ts=2 sw=2 et :
