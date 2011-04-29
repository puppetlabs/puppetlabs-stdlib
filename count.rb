#
# count.rb
#

# TODO(Krzysztof Wilczynski): We need to add support for regular expression ...
# TODO(Krzysztof Wilczynski): Support for hash values would be nice too ...

module Puppet::Parser::Functions
  newfunction(:count, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "count(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [Array, Hash, String].include?(klass)
      raise(Puppet::ParseError, 'count(): Requires either ' +
        'array, hash or string to work with')
    end

    item = arguments[1] if arguments[1]

    value = value.is_a?(Hash) ? value.keys : value

    # No item to look for and count?  Then just return current size ...
    result = item ? value.count(item) : value.size

    return result
  end
end

# vim: set ts=2 sw=2 et :
