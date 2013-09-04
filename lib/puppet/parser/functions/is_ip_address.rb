#
# is_ip_address.rb
#

module Puppet::Parser::Functions
  newfunction(:is_ip_address, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the string passed to this function is a valid IP address.
    EOS
  ) do |arguments|

    require 'ipaddr'

    begin
      ip = IPAddr.new(arguments[0])
    rescue ArgumentError
      return false
    end

    if ip.ipv4? or ip.ipv6? then
      return true
    else
      return false
    end
  end
end

# vim: set ts=2 sw=2 et :
