##
## netmask2cidr
##
module Puppet::Parser::Functions
  newfunction(
    :netmask2cidr,
    :type  => :rvalue,
    :arity => 1,
    :doc   => <<-EOS

This function Returns cidr value of netmask provided.

Example:

  netmask2cidr('255.255.255.0')

would return 24.

    EOS
  ) do |args|
  require 'ipaddr'
	IPAddr.new(args[0]).to_i.to_s(2).count("1")
  end
end

# vim:sts=2 sw=2

