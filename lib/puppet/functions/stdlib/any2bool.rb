# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# any2bool.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Converts 'anything' to a boolean.
#
#    In practise it does the following:
#    * Strings such as Y,y,1,T,t,TRUE,yes,'true' will return true
#    * Strings such as 0,F,f,N,n,FALSE,no,'false' will return false
#    * Booleans will just return their original value
#    * Number (or a string representation of a number) > 0 will return true, otherwise false
#    * undef will return false
#    * Anything else will return true
#
#    Also see the built-in [`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)
#    function.
#
#    @return [Boolean] The boolean value of the object that was given
#
#
Puppet::Functions.create_function(:'stdlib::any2bool') do
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
    raise(Puppet::ParseError, "any2bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    # If argument is already Boolean, return it
    if !!arguments[0] == arguments[0] # rubocop:disable Style/DoubleNegation : Could not find a better way to check if a boolean
      return arguments[0]
    end

    arg = arguments[0]

    if arg.nil?
      return false
    end

    if arg == :undef
      return false
    end

    valid_float = begin
                    !!Float(arg) # rubocop:disable Style/DoubleNegation : Could not find a better way to check if a boolean
                  rescue
                    false
                  end

    if arg.is_a?(Numeric)
      return function_num2bool([arguments[0]])
    end

    if arg.is_a?(String)
      return function_num2bool([arguments[0]]) if valid_float
      return function_str2bool([arguments[0]])
    end

    true
  end
end
