module Puppet::Parser::Functions
  newfunction(:array_contains, :type => :rvalue, :doc => <<-EOS
Returns true if the array contains this value.
  EOS
  ) do |arguments|
    needle = arguments[0]
    haystack = arguments[1]

    unless arguments.length == 2
      raise(Puppet::ParseError,
            "array_contains(): Wrong number of arguments provided. Usage: array_contains(needle, haystack)")
    end

    unless haystack.is_a?(Array)
      raise(Puppet::ParseError,
            "array_contains(): Second argument must be an array. Usage: array_contains(needle, haystack)"
      )
    end

    return haystack.include?(needle)
  end
end
