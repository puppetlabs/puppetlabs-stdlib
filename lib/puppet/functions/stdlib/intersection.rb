# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# intersection.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      This function returns an array of the intersection of two.
#
#    @return
#      an array of the intersection of two.
#
#    @example Example Usage:
#      intersection(["a","b","c"],["b","c","d"])  # returns ["b","c"]
#      intersection(["a","b","c"],[1,2,3,4])      # returns [] (true, when evaluated as a Boolean)
#
#
Puppet::Functions.create_function(:'stdlib::intersection') do
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
    raise(Puppet::ParseError, "intersection(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, "intersection(): Requires 2 arrays, got #{first.class} and #{second.class}")
    end

    result = first & second

    result
  end
end
