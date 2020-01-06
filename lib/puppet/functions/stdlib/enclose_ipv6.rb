# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# enclose_ipv6.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Takes an array of ip addresses and encloses the ipv6 addresses with square brackets.
#
#    @return
#      encloses the ipv6 addresses with square brackets.
#
#
#
Puppet::Functions.create_function(:'stdlib::enclose_ipv6') do
  # @param arguments
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :arguments
  end

  def default_impl(*arguments)
    require 'ipaddr'

    rescuable_exceptions = [ArgumentError]
    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    if arguments.size != 1
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong number of arguments given #{arguments.size} for 1")
    end
    unless arguments[0].is_a?(String) || arguments[0].is_a?(Array)
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument type given #{arguments[0].class} expected String or Array")
    end

    input = [arguments[0]].flatten.compact
    result = []

    input.each do |val|
      unless val == '*'
        begin
          ip = IPAddr.new(val)
        rescue *rescuable_exceptions
          raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument given #{val} is not an ip address.")
        end
        val = "[#{ip}]" if ip.ipv6?
      end
      result << val
    end

    result.uniq
  end
end
