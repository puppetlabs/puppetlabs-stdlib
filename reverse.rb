#
# reverse.rb
#

module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "reverse(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'reverse(): Requires an array to work with')
    end

    result = array.reverse

    return result
  end
end

# vim: set ts=2 sw=2 et :
