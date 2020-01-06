# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# is_numeric.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      **Deprecated:** Returns true if the given value is numeric.
#
#    Returns true if the given argument is a Numeric (Integer or Float),
#    or a String containing either a valid integer in decimal base 10 form, or
#    a valid floating point string representation.
#
#    The function recognizes only decimal (base 10) integers and float but not
#    integers in hex (base 16) or octal (base 8) form.
#
#    The string representation may start with a '-' (minus). If a decimal '.' is used,
#    it must be followed by at least one digit.
#
#    @return [Boolean]
#      Returns `true` or `false`
#
#    > **Note:* **Deprecated** Will be removed in a future version of stdlib. See
#    [`validate_legacy`](#validate_legacy).
#
#
Puppet::Functions.create_function(:'stdlib::is_numeric') do
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
    function_deprecation([:is_numeric, 'This method is deprecated, please use the stdlib validate_legacy function,
                          with Stdlib::Compat::Numeric. There is further documentation for validate_legacy function in the README.'])

    if arguments.size != 1
      raise(Puppet::ParseError, "is_numeric(): Wrong number of arguments given #{arguments.size} for 1")
    end

    value = arguments[0]

    # Regex is taken from the lexer of puppet
    # puppet/pops/parser/lexer.rb but modified to match also
    # negative values and disallow invalid octal numbers or
    # numbers prefixed with multiple 0's (except in hex numbers)
    #
    # TODO these parameters should be constants but I'm not sure
    # if there is no risk to declare them inside of the module
    # Puppet::Parser::Functions

    # TODO: decide if this should be used
    # HEX numbers like
    # 0xaa230F
    # 0X1234009C
    # 0x0012
    # -12FcD
    # numeric_hex = %r{^-?0[xX][0-9A-Fa-f]+$}

    # TODO: decide if this should be used
    # OCTAL numbers like
    # 01234567
    # -045372
    # numeric_oct = %r{^-?0[1-7][0-7]*$}

    # Integer/Float numbers like
    # -0.1234568981273
    # 47291
    # 42.12345e-12
    numeric = %r{^-?(?:(?:[1-9]\d*)|0)(?:\.\d+)?(?:[eE]-?\d+)?$}

    if value.is_a?(Numeric) || (value.is_a?(String) &&
      value.match(numeric) # or
                                 #  value.match(numeric_hex) or
                                 #  value.match(numeric_oct)
                               )
      return true
    else
      return false
    end
  end
end
