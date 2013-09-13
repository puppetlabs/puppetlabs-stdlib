#
#  rstrip.rb
#

module Puppet::Parser::Functions
  newfunction(:rstrip, :type => :rvalue, :arity => 1, :doc => <<-EOS
Strips leading spaces to the right of the string.
    EOS
  ) do |arguments|

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'rstrip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.rstrip : i }
    else
      result = value.rstrip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
