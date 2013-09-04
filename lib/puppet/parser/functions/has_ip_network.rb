#
# has_ip_network
#

module Puppet::Parser::Functions
  newfunction(:has_ip_network, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the client has an IP address within the requested network.

This function iterates through the 'interfaces' fact and checks the
'network_IFACE' facts, performing a simple string comparision.
    EOS
  ) do |args|

    Puppet::Parser::Functions.autoloader.load(:has_interface_with) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:has_interface_with)

    function_has_interface_with(['network', args[0]])

  end
end

# vim:sts=2 sw=2
