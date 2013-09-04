#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :arity => -2, :doc => <<-EOS
This function joins an array into a string using a seperator.

*Examples:*

    join(['a','b','c'], ",")

Would result in: "a,b,c"
    EOS
  ) do |arguments|

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
