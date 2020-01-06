# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# validate_ipv4_address.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Validate that all values passed are valid IPv4 addresses.
#      Fail compilation if any value fails this check.
#
#    @return
#      passes when the given values are valid IPv4 addresses or raise an error when they are not and fails compilation
#
#    @example **Usage**
#      The following values will pass:
#
#        $my_ip = "1.2.3.4"
#        validate_ipv4_address($my_ip)
#        validate_ipv4_address("8.8.8.8", "172.16.0.1", $my_ip)
#
#      The following values will fail, causing compilation to abort:
#
#        $some_array = [ 1, true, false, "garbage string", "3ffe:505:2" ]
#        validate_ipv4_address($some_array)
#
#
Puppet::Functions.create_function(:'stdlib::validate_ipv4_address') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

    function_deprecation([:validate_ipv4_address, 'This method is deprecated, please use the stdlib validate_legacy function,
                            with Stdlib::Compat::Ipv4. There is further documentation for validate_legacy function in the README.'])

    require 'ipaddr'
    rescuable_exceptions = [ArgumentError]

    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    if args.empty?
      raise Puppet::ParseError, "validate_ipv4_address(): wrong number of arguments (#{args.length}; must be > 0)"
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, "#{arg.inspect} is not a string."
      end

      begin
        unless IPAddr.new(arg).ipv4?
          raise Puppet::ParseError, "#{arg.inspect} is not a valid IPv4 address."
        end
      rescue *rescuable_exceptions
        raise Puppet::ParseError, "#{arg.inspect} is not a valid IPv4 address."
      end
    end
  
  end
end
