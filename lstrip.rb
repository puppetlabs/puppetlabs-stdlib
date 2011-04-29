#
#  lstrip.rb
#

module Puppet::Parser::Functions
  newfunction(:lstrip, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "lstrip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'lstrip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.lstrip : i }
    else
      result = value.lstrip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
