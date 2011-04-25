#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "join(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'join(): Requires an array to work with')
    end

    suffix = arguments[1] if arguments[1]

    result = suffix ? array.join(suffix) : array.join

    return result
  end
end

# vim: set ts=2 sw=2 et :
