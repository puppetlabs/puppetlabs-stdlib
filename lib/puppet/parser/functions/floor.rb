module Puppet::Parser::Functions
  newfunction(:floor, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Returns the largest integer less or equal to the argument.
    Takes a single numeric value as an argument.
    EOS
  ) do |arguments|

    arg = arguments[0]

    raise(Puppet::ParseError, "floor(): Wrong argument type " +
          "given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false

    arg.floor
  end
end

# vim: set ts=2 sw=2 et :
