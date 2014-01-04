#
# is_numeric.rb
#

module Puppet::Parser::Functions
  newfunction(:is_numeric, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is a number.

The function recognizes only integer and float but not hex or octal
numbers (for now) until a decision is made how to handle these types.

The parameter can be in the native format or given as string representation
of a number.

Valid examples:

  77435
  10e-12
  -8475
  0.2343
  -23.561e3
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_numeric(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
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

    # TODO decide if this should be used
    # HEX numbers like
    # 0xaa230F
    # 0X1234009C
    # 0x0012
    # -12FcD
    #numeric_hex = %r{^-?0[xX][0-9A-Fa-f]+$}

    # TODO decide if this should be used
    # OCTAL numbers like
    # 01234567
    # -045372
    #numeric_oct = %r{^-?0[1-7][0-7]*$}

    # Integer/Float numbers like
    # -0.1234568981273
    # 47291
    # 42.12345e-12
    numeric = %r{^-?(?:(?:[1-9]\d*)|0)(?:\.\d+)?(?:[eE]-?\d+)?$}

    if value.is_a? Numeric or
      value.to_s.match(numeric) #or
    #  value.to_s.match(numeric_hex) or
    #  value.to_s.match(numeric_oct)
      return true
    else
      return false
    end
  end
end

# vim: set ts=2 sw=2 et :
