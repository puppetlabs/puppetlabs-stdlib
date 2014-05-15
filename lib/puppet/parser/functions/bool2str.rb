#
# bool2str.rb
#

module Puppet::Parser::Functions
  newfunction(:bool2str, :type => :rvalue, :doc => <<-EOS
    Converts a boolean to a string.
    Requires a single boolean or string as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2str(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    # We can have either true or false, or string which resembles boolean ...
    unless [FalseClass, TrueClass, String].include?(klass)
      raise(Puppet::ParseError, 'bool2str(): Requires either ' +
        'boolean or string to work with')
    end

    result = value.is_a?(String) ? value : value.to_s

    return result
  end
end

# vim: set ts=2 sw=2 et :
