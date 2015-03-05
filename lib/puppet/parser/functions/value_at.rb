#
# value_at.rb
#

module Puppet::Parser::Functions
  newfunction(:value_at, :type => :rvalue, :doc => <<-EOS
This function will return the value of the given key in the given hash.

*Examples:*

    $hash = {
      'a' => 1,
      'b' => 2,
      'c' => 3,
    }
    value_at($hash, 'b')      # => 2
    value_at($hash, 'z', 10)  # => 10
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "value_at(): Wrong number of arguments " +
      "given (#{arguments.size} for at least 2)") if arguments.size < 2

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'value_at(): Requires hash to work with')
    end

    key     = arguments[1]
    default = arguments[2]

    result = hash[key] || default

    return result
  end
end
