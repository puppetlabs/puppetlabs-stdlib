#
# has_ip_address
#

module Puppet::Parser::Functions
  newfunction(:has_ip_address, :type => :rvalue, :doc => <<-EOS
Returns true if the client has the requested IP address on some interface.
    EOS
  ) do |arguments|

    addr = args[0]

    

  end
end

# vim:sts=2 sw=2
