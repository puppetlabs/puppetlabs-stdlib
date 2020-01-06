# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# delete_values.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Deletes all instances of a given value from a hash.
#
#    @example Example usage
#
#      delete_values({'a'=>'A','b'=>'B','c'=>'C','B'=>'D'}, 'B')
#      Would return: {'a'=>'A','c'=>'C','B'=>'D'}
#
#    > *Note:*
#    Since Puppet 4.0.0 the equivalent can be performed with the
#    built-in [`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:
#    $array.filter |$val| { $val != 'B' }
#    $hash.filter |$key, $val| { $val != 'B' }
#
#    @return [Hash] The given hash now missing all instances of the targeted value
#
#
Puppet::Functions.create_function(:'stdlib::delete_values') do
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
    

    raise(Puppet::ParseError, "delete_values(): Wrong number of arguments given (#{arguments.size} of 2)") if arguments.size != 2

    hash, item = arguments

    unless hash.is_a?(Hash)
      raise(TypeError, "delete_values(): First argument must be a Hash. Given an argument of class #{hash.class}.")
    end
    hash.dup.delete_if { |_key, val| item == val }
  
  end
end
