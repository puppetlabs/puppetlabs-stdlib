# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# join_keys_to_values.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      This function joins each key of a hash to that key's corresponding value with a
#      separator.
#
#    Keys are cast to strings. If values are arrays, multiple keys
#    are added for each element. The return value is an array in
#    which each element is one joined key/value pair.
#
#    @example Example Usage:
#      join_keys_to_values({'a'=>1,'b'=>2}, " is ") # Results in: ["a is 1","b is 2"]
#      join_keys_to_values({'a'=>1,'b'=>[2,3]}, " is ") # Results in: ["a is 1","b is 2","b is 3"]
#
#    @return [Hash]
#      The joined hash
#
#    > **Note:** Since Puppet 5.0.0 - for more detailed control over the formatting (including indentations and
#    line breaks, delimiters around arrays and hash entries, between key/values in hash entries, and individual
#    formatting of values in the array) - see the `new` function for `String` and its formatting
#    options for `Array` and `Hash`.
#
#
Puppet::Functions.create_function(:'stdlib::join_keys_to_values') do
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
    # Validate the number of arguments.
    if arguments.size != 2
      raise(Puppet::ParseError, "join_keys_to_values(): Takes exactly two arguments, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    unless hash.is_a?(Hash)
      raise(TypeError, "join_keys_to_values(): The first argument must be a hash, but a #{hash.class} was given.")
    end

    # Validate the second argument.
    separator = arguments[1]
    unless separator.is_a?(String)
      raise(TypeError, "join_keys_to_values(): The second argument must be a string, but a #{separator.class} was given.")
    end

    # Join the keys to their values.
    hash.map { |k, v|
      if v.is_a?(Array)
        v.map { |va| String(k) + separator + String(va) }
      elsif String(v) == 'undef'
        String(k)
      else
        String(k) + separator + String(v)
      end
    }.flatten
  end
end
