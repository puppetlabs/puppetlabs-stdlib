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

    return []    if array.size == 0
    return array if array.size <= 1

    list     = array.clone
    elements = list.size

    # Simple implementation of Fisher–Yates in-place shuffle ...
    elements.times do |i|
      j = rand(elements - i) + i
      list[j], list[i] = list[i], list[j]
    end

    return list
  end
end

# vim: set ts=2 sw=2 et :
