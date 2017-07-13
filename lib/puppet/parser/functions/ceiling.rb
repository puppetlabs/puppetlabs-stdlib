module Puppet::Parser::Functions
  newfunction(:ceiling, :type => :rvalue, :doc => _(<<-EOS)
    Returns the smallest integer greater or equal to the argument.
    Takes a single numeric value as an argument.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("ceiling(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => e
      raise(Puppet::ParseError, _("ceiling(): Wrong argument type given (%{arg_type} for Numeric)") % { arg_type: arguments[0], })
    end

    raise(Puppet::ParseError, _("ceiling(): Wrong argument type given (%{arg_class} for Numeric)") % { arg_class: arg.class, }) if arg.is_a?(Numeric) == false

    arg.ceil
  end
end

# vim: set ts=2 sw=2 et :
