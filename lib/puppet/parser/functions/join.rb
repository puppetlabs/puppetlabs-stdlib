#
# join.rb
#
module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated:** This function joins an array into a string using a separator.

    @example Example Usage:
      join(['a','b','c'], ",") # Results in: "a,b,c"

    @return [String]
      The String containing each of the array values

    > **Note:** **Deprecated** from Puppet 5.4.0 this function has been replaced
    with a built-in [`join`](https://puppet.com/docs/puppet/latest/function.html#join) function.
    DOC
             ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "join(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'join(): Requires array to work with')
    end

    suffix = arguments[1] if arguments[1]

    if suffix
      unless suffix.is_a?(String)
        raise(Puppet::ParseError, 'join(): Requires string to work with')
      end
    end

    result = suffix ? array.join(suffix) : array.join

    return result
  end
end

# vim: set ts=2 sw=2 et :
