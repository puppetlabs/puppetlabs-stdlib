#
# shuffle.rb
#

module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "shuffle(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'shuffle(): Requires an array to work with')
    end

    result   = array.clone
    elements = result.size

    return []     if result.size == 0
    return result if result.size <= 1

    # Simple implementation of Fisher–Yates in-place shuffle ...
    elements.times do |i|
      j = rand(elements - i) + i
      result[j], result[i] = result[i], result[j]
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
