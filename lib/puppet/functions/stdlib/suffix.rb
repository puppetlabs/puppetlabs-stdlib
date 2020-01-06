# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# suffix.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      This function applies a suffix to all elements in an array, or to the keys
#      in a hash.
#
#    @return
#      Array or Hash with updated elements containing the passed suffix
#
#    @example **Usage**
#
#      suffix(['a','b','c'], 'p')
#      Will return: ['ap','bp','cp']
#
#    > *Note:* that since Puppet 4.0.0 the general way to modify values is in array is by using the map
#    function in Puppet. This example does the same as the example above:
#
#    ```['a', 'b', 'c'].map |$x| { "${x}p" }```
#
#
#
Puppet::Functions.create_function(:'stdlib::suffix') do
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
    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "suffix(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    enumerable = arguments[0]

    unless enumerable.is_a?(Array) || enumerable.is_a?(Hash)
      raise Puppet::ParseError, "suffix(): expected first argument to be an Array or a Hash, got #{enumerable.inspect}"
    end

    suffix = arguments[1] if arguments[1]

    if suffix
      unless suffix.is_a? String
        raise Puppet::ParseError, "suffix(): expected second argument to be a String, got #{suffix.inspect}"
      end
    end

    result = if enumerable.is_a?(Array)
               # Turn everything into string same as join would do ...
               enumerable.map do |i|
                 i = i.to_s
                 suffix ? i + suffix : i
               end
             else
               Hash[enumerable.map do |k, v|
                 k = k.to_s
                 [suffix ? k + suffix : k, v]
               end]
             end

    result
  end
end
