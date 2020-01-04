# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# reverse.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Reverses the order of a string or array.
#
#    @return
#      reversed string or array
#
#    > *Note:* that the same can be done with the reverse_each() function in Puppet.
#
#
Puppet::Functions.create_function(:'stdlib::reverse') do
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
    

    raise(Puppet::ParseError, "reverse(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'reverse(): Requires either array or string to work with')
    end

    result = value.reverse

    return result
  
  end
end
