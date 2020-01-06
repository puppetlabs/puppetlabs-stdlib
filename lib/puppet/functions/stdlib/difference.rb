# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# difference.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      This function returns the difference between two arrays.
#
#    The returned array is a copy of the original array, removing any items that
#    also appear in the second array.
#
#    @example Example usage
#
#      difference(["a","b","c"],["b","c","d"])
#      Would return: `["a"]`
#
#    > *Note:*
#    Since Puppet 4 the minus (-) operator in the Puppet language does the same thing:
#    ['a', 'b', 'c'] - ['b', 'c', 'd']
#    Would return: `['a']`
#
#    @return [Array]
#      The difference between the two given arrays
#
#
#
Puppet::Functions.create_function(:'stdlib::difference') do
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
    # Two arguments are required
    raise(Puppet::ParseError, "difference(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, 'difference(): Requires 2 arrays')
    end

    result = first - second

    result
  end
end
