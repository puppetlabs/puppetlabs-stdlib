#
# is_mac_address.rb
#

module Puppet::Parser::Functions
  newfunction(:is_mac_address, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the string passed to this function is a valid mac address.
    EOS
  ) do |arguments|

    mac = arguments[0]

    if /^[a-fA-F0-9]{1,2}:[a-fA-F0-9]{1,2}:[a-fA-F0-9]{1,2}:[a-fA-F0-9]{1,2}:[a-fA-F0-9]{1,2}:[a-fA-F0-9]{1,2}$/.match(mac) then
      return true
    else
      return false
    end

  end
end

# vim: set ts=2 sw=2 et :
