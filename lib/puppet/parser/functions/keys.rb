#
# keys.rb
#
module Puppet::Parser::Functions
  newfunction(:keys, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated:** Returns the keys of a hash as an array.

    @return [Array]
      An array containing each of the hashes key values.

    > **Note:** **Deprecated** from Puppet 5.5.0, the built-in [`keys`](https://puppet.com/docs/puppet/latest/function.html#keys)
    function will be used instead of this function.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "keys(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'keys(): Requires hash to work with')
    end

    result = hash.keys

    return result
  end
end

# vim: set ts=2 sw=2 et :
