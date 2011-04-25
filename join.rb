#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support three arguments but only first two are mandatory ...
    raise(Puppet::ParseError, "join(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'join(): Requires an array to work with')
    end

    suffix = arguments[1]
    prefix = arguments[2] if arguments[2]

    raise(Puppet::ParseError, 'join(): You must provide suffix ' +
      'to join array elements with') if suffix.empty?

    if prefix and prefix.empty?
      raise(Puppet::ParseError, 'join(): You must provide prefix ' +
        'to add to join')
    end

    if prefix and not prefix.empty?
      result = prefix + array.join(suffix + prefix)
    else
      result = array.join(suffix)
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
