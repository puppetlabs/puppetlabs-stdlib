#
# shuffle.rb
#

module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :doc => _(<<-EOS)
Randomizes the order of a string or array elements.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("shuffle(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('shuffle(): Requires either array or string to work with'))
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
