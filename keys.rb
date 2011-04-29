#
# keys.rb
#

module Puppet::Parser::Functions
  newfunction(:keys, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "keys(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    hash = arguments[0]

    if not hash.is_a?(Hash)
      raise(Puppet::ParseError, 'keys(): Requires a hash to work with')
    end

    result = hash.keys

    return result
  end
end

# vim: set ts=2 sw=2 et :
