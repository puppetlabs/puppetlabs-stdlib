# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
#  sort.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
# ---- original file header ----
#
# @summary
#       @summary
#      Sorts strings and arrays lexically.
#
#    @return
#      sorted string or array
#
#    Note that from Puppet 6.0.0 the same function in Puppet will be used instead of this.
#
#
Puppet::Functions.create_function(:'stdlib::sort') do
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
    if arguments.size != 1
      raise(Puppet::ParseError, "sort(): Wrong number of arguments given #{arguments.size} for 1")
    end

    value = arguments[0]

    if value.is_a?(Array)
      value.sort
    elsif value.is_a?(String)
      value.split('').sort.join('')
    end
  end
end
