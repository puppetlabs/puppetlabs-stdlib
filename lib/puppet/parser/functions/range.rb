#
# range.rb
#

# TODO(Krzysztof Wilczynski): We probably need to approach numeric values differently ...

module Puppet::Parser::Functions
  newfunction(:range, :type => :rvalue, :doc => <<-EOS
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

    # We support more than one argument but at least one is mandatory ...
    raise(Puppet::ParseError, "range(): Wrong number of " +
      "arguments given (#{arguments.size} for 1)") if arguments.size < 1

    start = arguments[0]
    stop  = arguments[1]
    step  = arguments[2].nil? ? 1 : arguments[2].to_i.abs

    # Check whether we have integer value if so then make it so ...
    if start.to_s.match(/^\d+$/)
      start = start.to_i
      stop  = stop.to_i
    else
      start = start.to_s
      stop  = stop.to_s
    end

    # We select simplest type for Range available in Ruby ...
    range = (start .. stop)

    range.step(step).collect { |i| i } # Get them all ... Pokemon ...
  end
end

# vim: set ts=2 sw=2 et :
