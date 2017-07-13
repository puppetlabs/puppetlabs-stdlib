#
# has_ip_address
#

module Puppet::Parser::Functions
  newfunction(:has_ip_address, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the client has the requested IP address on some interface.

This function iterates through the 'interfaces' fact and checks the
'ipaddress_IFACE' facts, performing a simple string comparison.
    EOS
  ) do |args|

    raise(Puppet::ParseError, _("has_ip_address(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: args.size, }) if args.size != 1

    Puppet::Parser::Functions.autoloader.load(:has_interface_with) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:has_interface_with)

    function_has_interface_with(['ipaddress', args[0]])

  end
end

# vim:sts=2 sw=2
