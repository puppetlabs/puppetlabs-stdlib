module Puppet::Parser::Functions
  newfunction(:floor, :type => :rvalue, :doc => _(<<-EOS)
    Returns the largest integer less or equal to the argument.
    Takes a single numeric value as an argument.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("floor(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => e
      raise(Puppet::ParseError, _("floor(): Wrong argument type given (%{val} for Numeric)") % { val: arguments[0] })
    end

    raise(Puppet::ParseError, _("floor(): Wrong argument type given (%{arg_class} for Numeric)") % { arg_class: arg.class }) if arg.is_a?(Numeric) == false

    arg.floor
  end
end

# vim: set ts=2 sw=2 et :
