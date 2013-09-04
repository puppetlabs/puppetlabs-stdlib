#
#  lstrip.rb
#

module Puppet::Parser::Functions
  newfunction(:lstrip, :type => :rvalue, :arity => 1, :doc => <<-EOS
Strips leading spaces to the left of a string.
    EOS
  ) do |arguments|

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'lstrip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.lstrip : i }
    else
      result = value.lstrip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
