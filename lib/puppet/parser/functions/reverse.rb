#
# reverse.rb
#

module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :arity => 1, :doc => <<-EOS
Reverses the order of a string or array.
    EOS
  ) do |arguments|

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'reverse(): Requires either ' +
        'array or string to work with')
    end

    result = value.reverse

    return result
  end
end

# vim: set ts=2 sw=2 et :
