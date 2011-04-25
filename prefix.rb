#
# prefix.rb
#

module Puppet::Parser::Functions
  newfunction(:prefix, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "prefix(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'prefix(): Requires an array to work with')
    end

    prefix = arguments[1] if arguments[1]

    result = array.collect { |i| prefix ? prefix + i : i }

    return result
  end
end

# vim: set ts=2 sw=2 et :

