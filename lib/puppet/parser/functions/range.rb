#
# range.rb
#

# TODO(Krzysztof Wilczynski): We probably need to approach numeric values differently ...

module Puppet::Parser::Functions
  newfunction(:range, :type => :rvalue, :arity => -2, :doc => <<-EOS
When given range in the form of (start, stop) it will extrapolate a range as
an array.

*Examples:*

    range("0", "9")

Will return: [0,1,2,3,4,5,6,7,8,9]

    range("00", "09")

Will return: [0,1,2,3,4,5,6,7,8,9] (Zero padded strings are converted to
integers automatically)

    range("a", "c")

Will return: ["a","b","c"]

    range("host01", "host10")

Will return: ["host01", "host02", ..., "host09", "host10"]

Passing a third argument will cause the generated range to step by that
interval, e.g.

    range("0", "9", "2")

Will return: [0,2,4,6,8]
    EOS
  ) do |arguments|

    if arguments.size > 1
      start = arguments[0]
      stop  = arguments[1]
      step  = arguments[2].nil? ? 1 : arguments[2].to_i.abs

      type = '..' # We select simplest type for Range available in Ruby ...

    else
      value = arguments[0]

      if m = value.match(/^(\w+)(\.\.\.?|\-)(\w+)$/)
        start = m[1]
        stop  = m[3]

        type = m[2]

      elsif value.match(/^.+$/)
        raise(Puppet::ParseError, 'range(): Unable to compute range ' +
          'from the value given')
      else
        raise(Puppet::ParseError, 'range(): Unknown format of range given')
      end
    end

      # Check whether we have integer value if so then make it so ...
      if start.match(/^\d+$/)
        start = start.to_i
        stop  = stop.to_i
      else
        start = start.to_s
        stop  = stop.to_s
      end

      range = case type
        when /^(\.\.|\-)$/ then (start .. stop)
        when /^(\.\.\.)$/  then (start ... stop) # Exclusive of last element ...
      end

      result = range.step(step).collect { |i| i } # Get them all ... Pokemon ...

    return result
  end
end

# vim: set ts=2 sw=2 et :
