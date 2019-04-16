#
#  ceiling.rb
#
module Puppet::Parser::Functions
  newfunction(:ceiling, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated** Returns the smallest integer greater or equal to the argument.
    Takes a single numeric value as an argument.

    > *Note:* **Deprecated** from Puppet 6.0.0, this function has been replaced with a
    built-in [`ceiling`](https://puppet.com/docs/puppet/latest/function.html#ceiling) function.

    @return [Integer] The rounded value
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "ceiling(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => _e
      raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arguments[0]} for Numeric)")
    end

    raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false

    arg.ceil
  end
end

# vim: set ts=2 sw=2 et :
