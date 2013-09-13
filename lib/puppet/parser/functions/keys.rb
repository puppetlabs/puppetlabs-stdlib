#
# keys.rb
#

module Puppet::Parser::Functions
  newfunction(:keys, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns the keys of a hash as an array.
    EOS
  ) do |arguments|

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'keys(): Requires hash to work with')
    end

    result = hash.keys

    return result
  end
end

# vim: set ts=2 sw=2 et :
