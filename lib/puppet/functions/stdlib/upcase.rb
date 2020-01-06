# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
#  upcase.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
# ---- original file header ----
#
# @summary
#       @summary
#      Converts a string or an array of strings to uppercase.
#
#    @return
#      converted string ot array of strings to uppercase
#
#    @example **Usage**
#
#      upcase("abcd")
#      Will return ABCD
#
#    > *Note:* from Puppet 6.0.0, the compatible function with the same name in Puppet core
#    will be used instead of this function.
#
#
Puppet::Functions.create_function(:'stdlib::upcase') do
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
    raise(Puppet::ParseError, "upcase(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(Hash) || value.respond_to?(:upcase)
      raise(Puppet::ParseError, 'upcase(): Requires an array, hash or object that responds to upcase in order to work')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.map { |i| function_upcase([i]) }
    elsif value.is_a?(Hash)
      result = {}
      value.each_pair do |k, v|
        result[function_upcase([k])] = function_upcase([v])
      end
    else
      result = value.upcase
    end

    result
  end
end
