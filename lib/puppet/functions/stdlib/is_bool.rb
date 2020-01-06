# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# is_bool.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      **Deprecated:** Returns true if the variable passed to this function is a boolean.
#
#    @return [Boolean]
#      Returns `true` or `false`
#
#    > **Note:* **Deprecated** Will be removed in a future version of stdlib. See
#    [`validate_legacy`](#validate_legacy).
#
#
Puppet::Functions.create_function(:'stdlib::is_bool') do
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
    function_deprecation([:is_bool, 'This method is deprecated, please use the stdlib validate_legacy function,
                          with Stdlib::Compat::Bool. There is further documentation for validate_legacy function in the README.'])

    raise(Puppet::ParseError, "is_bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    type = arguments[0]

    result = type.is_a?(TrueClass) || type.is_a?(FalseClass)

    result
  end
end
