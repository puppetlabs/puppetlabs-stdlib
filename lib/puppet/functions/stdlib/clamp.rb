# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# clamp.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Keeps value within the range [Min, X, Max] by sort based on integer value
#      (parameter order doesn't matter).
#
#    Strings are converted and compared numerically. Arrays of values are flattened
#    into a list for further handling.
#
#    @example Example usage
#
#      clamp('24', [575, 187])` returns 187.
#      clamp(16, 88, 661)` returns 88.
#      clamp([4, 3, '99'])` returns 4.
#
#    > *Note:*
#      From Puppet 6.0.0 this can be done with only core Puppet like this:
#      `[$minval, $maxval, $value_to_clamp].sort[1]`
#
#    @return [Array[Integer]] The sorted Array
#
#
Puppet::Functions.create_function(:'stdlib::clamp') do
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
    args.flatten!

    raise(Puppet::ParseError, 'clamp(): Wrong number of arguments, need three to clamp') if args.size != 3

    # check values out
    args.each do |value|
      case [value.class]
      when [String]
        raise(Puppet::ParseError, "clamp(): Required explicit numeric (#{value}:String)") unless value =~ %r{^\d+$}
      when [Hash]
        raise(Puppet::ParseError, "clamp(): The Hash type is not allowed (#{value})")
      end
    end

    # convert to numeric each element
    # then sort them and get a middle value
    args.map { |n| n.to_i }.sort[1]
  end
end
