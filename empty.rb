#
# empty.rb
#

# TODO(Krzysztof Wilczynski): Support for hashes would be nice too ...

module Puppet::Parser::Functions
  newfunction(:empty, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "empty(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    if not [Array, Hash, String].include?(klass)
      raise(Puppet::ParseError, 'empty(): Requires either an ' +
        'array, hash or string to work with')
    end

    result = value.empty?

    return result
  end
end

# vim: set ts=2 sw=2 et :
