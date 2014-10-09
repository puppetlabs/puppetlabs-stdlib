#
# shuffle.rb
#

module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :arity => 1, :doc => <<-EOS
Randomizes the order of a string or array elements.
    EOS
  ) do |arguments|

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'shuffle(): Requires either ' +
        'array or string to work with')
    end

    result = value.clone

    string = value.is_a?(String) ? true : false

    # Check whether it makes sense to shuffle ...
    return result if result.size <= 1

    # We turn any string value into an array to be able to shuffle ...
    result = string ? result.split('') : result

    elements = result.size

    # Simple implementation of Fisher–Yates in-place shuffle ...
    elements.times do |i|
      j = rand(elements - i) + i
      result[j], result[i] = result[i], result[j]
    end

    result = string ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
