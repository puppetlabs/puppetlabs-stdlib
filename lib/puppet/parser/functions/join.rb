#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
This function joins an array or a number of strings into a string using a
separator. If used with strings, the separator is mandatory, although it can be
just an empty string.

*Examples:*

    $var = ['a','b','c']
    join($var, ',')

would result in: "a,b,c"

    join('a', 'b')

would result in: "ab"

    join('a','b', ',')

would result in: "a,b"

    join('a','b','c', ',')

would result in: "a,b,c"
    EOS
  ) do |arguments|

    argc = arguments.size

    raise(Puppet::ParseError, "join(): Wrong number of arguments #{argc} " +
      "given") if argc < 1

    array = arguments[0]
    suffix = arguments[1] if arguments[1]

    unless array.is_a?(Array)
      if argc == 1
        raise(Puppet::ParseError, 'join(): Requires array or at least 2 strings to work with')
      elsif argc == 2
        array = arguments
        suffix = false
      else argc > 2
        array = arguments[0..-2]
        suffix = arguments[-1]
      end
    end

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
