#
# is_domain_name.rb
#

module Puppet::Parser::Functions
  newfunction(:is_domain_name, :type => :rvalue, :doc => <<-EOS
Returns true if the string passed to this function is a valid IP address. Support for IPv4 and IPv6 address types is included.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_domain_name(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    domain = arguments[0]

    if domain =~ /^(([a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\.?$/ then
      return true
    else
      return false
    end

  end
end

# vim: set ts=2 sw=2 et :
