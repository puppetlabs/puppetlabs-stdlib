#
# bool2num.rb
#
module Puppet::Parser::Functions
  newfunction(:bool2num, :type => :rvalue, :doc => <<-DOC
    Converts a boolean to a number. Converts the values:
      false, f, 0, n, and no to 0
      true, t, 1, y, and yes to 1
    Requires a single boolean or string as an input.

    Note that since Puppet 5.0.0 it is possible to create new data types for almost any
    datatype using the type system and the built-in
    [`Numeric.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-numeric),
    [`Integer.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-integer), and
    [`Float.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-float)
    function are used to convert to numeric values.

        notice(Integer(false)) # Notices 0
        notice(Float(true))    # Notices 1.0
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "bool2num(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = function_str2bool([arguments[0]])

    # We have real boolean values as well ...
    result = value ? 1 : 0

    return result
  end
end

# vim: set ts=2 sw=2 et :
