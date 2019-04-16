#
# is_integer.rb
#
module Puppet::Parser::Functions
  newfunction(:is_integer, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated:** Returns true if the variable passed to this function is an Integer or
      a decimal (base 10) integer in String form.

    The string may start with a '-' (minus). A value of '0' is allowed, but a leading '0'
    digit may not be followed by other digits as this indicates that the value is octal (base 8).

    If given any other argument `false` is returned.

    @return [Boolean]
      Returns `true` or `false`

    > **Note:* **Deprecated** Will be removed in a future version of stdlib. See
    [`validate_legacy`](#validate_legacy).
    DOC
             ) do |arguments|

    function_deprecation([:is_integer, 'This method is deprecated, please use the stdlib validate_legacy function,
                            with Stdlib::Compat::Integer. There is further documentation for validate_legacy function in the README.'])

    if arguments.size != 1
      raise(Puppet::ParseError, "is_integer(): Wrong number of arguments given #{arguments.size} for 1")
    end

    value = arguments[0]

    # Regex is taken from the lexer of puppet
    # puppet/pops/parser/lexer.rb but modified to match also
    # negative values and disallow numbers prefixed with multiple
    # 0's
    #
    # TODO these parameter should be a constant but I'm not sure
    # if there is no risk to declare it inside of the module
    # Puppet::Parser::Functions

    # Integer numbers like
    # -1234568981273
    # 47291
    numeric = %r{^-?(?:(?:[1-9]\d*)|0)$}

    return true if value.is_a?(Integer) || (value.is_a?(String) && value.match(numeric))
    return false
  end
end

# vim: set ts=2 sw=2 et :
