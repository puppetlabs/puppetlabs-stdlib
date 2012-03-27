#
# has_ip_address
#

module Puppet::Parser::Functions
  newfunction(:has_ip_address, :type => :rvalue, :doc => <<-EOS
Returns true if the client has the requested IP address on some interface.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "has_ip_address(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size != 1

    query_addr = args[0]
    result = false

    lookupvar('interfaces').split(',').each do |iface|
      if query_addr == lookupvar("ipaddress_#{iface}")
        result = true
        break
      end
    end
    result
  end
end

# vim:sts=2 sw=2
