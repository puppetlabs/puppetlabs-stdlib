#
# shuffle.rb
#

module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "shuffle(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    if not [Array, String].include?(klass)
      raise(Puppet::ParseError, 'shuffle(): Requires either an ' +
        'array or string to work with')
    end

    string_given = false

    result = value.clone

    if value.is_a?(String)
      result = result.split('')
      string_given = true
    end

    elements = result.size

    return []     if result.size == 0
    return result if result.size <= 1

    # Simple implementation of Fisher–Yates in-place shuffle ...
    elements.times do |i|
      j = rand(elements - i) + i
      result[j], result[i] = result[i], result[j]
    end

    result = string_given ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
