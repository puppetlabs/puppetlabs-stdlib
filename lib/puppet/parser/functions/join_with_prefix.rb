#
# join_with_prefix.rb
#

module Puppet::Parser::Functions
  newfunction(:join_with_prefix, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support three arguments but only first is mandatory ...
    raise(Puppet::ParseError, "join(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'join_with_prefix(): Requires ' +
        'array to work with')
    end

    prefix = arguments[1] if arguments[1]
    suffix = arguments[2] if arguments[2]

    if prefix and suffix
      result = prefix + array.join(suffix + prefix)
    elsif prefix and not suffix
      result = array.collect { |i| prefix ? prefix + i : i }
    elsif suffix and not prefix
      result = array.join(suffix)
    else
      result = array.join
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
