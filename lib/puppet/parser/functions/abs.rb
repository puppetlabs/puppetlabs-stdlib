#
# abs.rb
#
module Puppet::Parser::Functions
  newfunction(:abs, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated:** Returns the absolute value of a number

    For example -34.56 becomes 34.56.
    Takes a single integer or float value as an argument.

    > *Note:*
      **Deprected** from Puppet 6.0.0, the built-in
      ['abs'](https://puppet.com/docs/puppet/6.4/function.html#abs)function will be used instead.

    @return The absolute value of the given number if it was an Integer

    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "abs(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    # Numbers in Puppet are often string-encoded which is troublesome ...
    if value.is_a?(String)
      if value =~ %r{^-?(?:\d+)(?:\.\d+){1}$}
        value = value.to_f
      elsif value =~ %r{^-?\d+$}
        value = value.to_i
      else
        raise(Puppet::ParseError, 'abs(): Requires float or integer to work with')
      end
    end

    # We have numeric value to handle ...
    result = value.abs

    return result
  end
end

# vim: set ts=2 sw=2 et :
