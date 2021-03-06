# frozen_string_literal: true

#
# validate_ipv6_address.rb
#
module Puppet::Parser::Functions
  newfunction(:validate_ipv6_address, doc: <<-DOC
    @summary
      Validate that all values passed are valid IPv6 addresses.
      Fail compilation if any value fails this check.

    @return
      passes when the given values are valid IPv6 addresses or raise an error when they are not and fails compilation

    @example **Usage**
      The following values will pass:

        $my_ip = "3ffe:505:2"
        validate_ipv6_address(1)
        validate_ipv6_address($my_ip)
        validate_bool("fe80::baf6:b1ff:fe19:7507", $my_ip)

      The following values will fail, causing compilation to abort:

        $some_array = [ true, false, "garbage string", "1.2.3.4" ]
        validate_ipv6_address($some_array)

    DOC
  ) do |args|
    function_deprecation([:validate_ipv6_address, 'This method is deprecated, please use the stdlib validate_legacy function,
                            with Stdlib::Compat::Ipv6. There is further documentation for validate_legacy function in the README.'])

    require 'ipaddr'
    rescuable_exceptions = [ArgumentError]

    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    if args.empty?
      raise Puppet::ParseError, "validate_ipv6_address(): wrong number of arguments (#{args.length}; must be > 0)"
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, "#{arg.inspect} is not a string."
      end

      begin
        unless IPAddr.new(arg).ipv6?
          raise Puppet::ParseError, "#{arg.inspect} is not a valid IPv6 address."
        end
      rescue *rescuable_exceptions
        raise Puppet::ParseError, "#{arg.inspect} is not a valid IPv6 address."
      end
    end
  end
end
