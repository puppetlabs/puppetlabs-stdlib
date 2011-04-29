#
# count.rb
#

# TODO(Krzysztof Wilczynski): We need to add support for regular expression ...
# TODO(Krzysztof Wilczynski): Support for strings and hashes too ..

module Puppet::Parser::Functions
  newfunction(:count, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "count(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'count(): Requires array to work with')
    end

    item = arguments[1] if arguments[1]

    result = item ? array.count(item) : array.count

    return result
  end
end

# vim: set ts=2 sw=2 et :
