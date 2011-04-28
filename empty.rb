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

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'empty(): Requires an array to work with')
    end

    result = array.empty?

    return result
  end
end

# vim: set ts=2 sw=2 et :
