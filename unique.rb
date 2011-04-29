#
# unique.rb
#

module Puppet::Parser::Functions
  newfunction(:unique, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "unique(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    if not [Array, String].include?(klass)
      raise(Puppet::ParseError, 'unique(): Requires either an ' +
        'array or string to work with')
    end

    result = value.clone

    string_type = value.is_a?(String) ? true : false

    # We turn any string value into an array to be able to shuffle ...
    result = string_type ? result.split('') : result

    result = result.uniq

    result = string_type ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
