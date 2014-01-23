#
# is_integer.rb
#

module Puppet::Parser::Functions
  newfunction(:is_integer, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is an integer.

If the variable is a string it has to be in the correct format of an
integer.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_integer(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
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

    if value.is_a? Integer or (value.is_a? String and value.match numeric)
      return true
    else
      return false
    end
  end
end

# vim: set ts=2 sw=2 et :
