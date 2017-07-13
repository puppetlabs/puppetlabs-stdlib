#
# is_integer.rb
#

module Puppet::Parser::Functions
  newfunction(:is_integer, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable passed to this function is an Integer or
a decimal (base 10) integer in String form. The string may
start with a '-' (minus). A value of '0' is allowed, but a leading '0' digit may not
be followed by other digits as this indicates that the value is octal (base 8).

If given any other argument `false` is returned.
    EOS
  ) do |arguments|

    function_deprecation([:is_integer, _('This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Integer. There is further documentation for validate_legacy function in the README.')])

    if (arguments.size != 1) then
      raise(Puppet::ParseError, _("is_integer(): Wrong number of arguments given %{num_args} for 1") % { num_args: arguments.size })
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
