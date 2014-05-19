module Puppet::Parser::Functions
  newfunction(:truncate, :type => :rvalue, :doc => <<-EOS
    Truncates a given string or array of strings to x chars maximum.
    Requires either a single string or an array as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "truncate(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    value = arguments[0]
    max   = arguments[1].to_i
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'truncate(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i[0..max] : i }
    else
      result = value[0..max]
    end

    return result
  end
end
