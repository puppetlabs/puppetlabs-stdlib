#
#  capitalize.rb
#

module Puppet::Parser::Functions
  newfunction(:capitalize, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "capitalize(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    if not [Array, String].include?(klass)
      raise(Puppet::ParseError, 'capitalize(): Requires either an ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.capitalize : i }
    else
      result = value.capitalize
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
