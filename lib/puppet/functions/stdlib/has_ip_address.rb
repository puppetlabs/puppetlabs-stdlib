# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# has_ip_address
#
# ---- original file header ----
#
# @summary
#       @summary
#      Returns true if the client has the requested IP address on some interface.
#
#    @return [Boolean]
#      `true` or `false`
#
#    This function iterates through the 'interfaces' fact and checks the
#    'ipaddress_IFACE' facts, performing a simple string comparison.
#
#
Puppet::Functions.create_function(:'stdlib::has_ip_address') do
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
    raise(Puppet::ParseError, "has_ip_address(): Wrong number of arguments given (#{args.size} for 1)") if args.size != 1

    Puppet::Parser::Functions.autoloader.load(:has_interface_with) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:has_interface_with)

    function_has_interface_with(['ipaddress', args[0]])
  end
end
