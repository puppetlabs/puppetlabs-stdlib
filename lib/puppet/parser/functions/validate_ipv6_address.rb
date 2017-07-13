module Puppet::Parser::Functions

  newfunction(:validate_ipv6_address, :doc => _(<<-ENDHEREDOC)
    Validate that all values passed are valid IPv6 addresses.
    Fail compilation if any value fails this check.

    The following values will pass:

    $my_ip = "3ffe:505:2"
    validate_ipv6_address(1)
    validate_ipv6_address($my_ip)
    validate_bool("fe80::baf6:b1ff:fe19:7507", $my_ip)

    The following values will fail, causing compilation to abort:

    $some_array = [ true, false, "garbage string", "1.2.3.4" ]
    validate_ipv6_address($some_array)

    ENDHEREDOC
  ) do |args|

    function_deprecation([:validate_ipv6_address, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Ipv6. There is further documentation for validate_legacy function in the README.'])

    require "ipaddr"
    rescuable_exceptions = [ ArgumentError ]

    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    unless args.length > 0 then
      raise Puppet::ParseError, (_("validate_ipv6_address(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length, })
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, _("%{arg} is not a string.") % { arg: arg.inspect, }
      end

      begin
        unless IPAddr.new(arg).ipv6?
          raise Puppet::ParseError, _("%{arg} is not a valid IPv6 address.") % { arg: arg.inspect, }
        end
      rescue *rescuable_exceptions
        raise Puppet::ParseError, _("%{arg} is not a valid IPv6 address.") % { arg: arg.inspect, }
      end
    end

  end

end
