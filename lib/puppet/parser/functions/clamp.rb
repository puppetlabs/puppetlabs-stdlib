#
# clamp.rb
#
module Puppet::Parser::Functions
  newfunction(:clamp, :type => :rvalue, :arity => -2, :doc => <<-DOC
    @summary
      Keeps value within the range [Min, X, Max] by sort based on integer value
      (parameter order doesn't matter).

    Strings are converted and compared numerically. Arrays of values are flattened
    into a list for further handling.

    @example Example usage

      clamp('24', [575, 187])` returns 187.
      clamp(16, 88, 661)` returns 88.
      clamp([4, 3, '99'])` returns 4.

    > *Note:*
      From Puppet 6.0.0 this can be done with only core Puppet like this:
      `[$minval, $maxval, $value_to_clamp].sort[1]`

    @return [Array[Integer]] The sorted Array
    DOC
             ) do |args|

    args.flatten!

    raise(Puppet::ParseError, 'clamp(): Wrong number of arguments, need three to clamp') if args.size != 3

    # check values out
    args.each do |value|
      case [value.class]
      when [String]
        raise(Puppet::ParseError, "clamp(): Required explicit numeric (#{value}:String)") unless value =~ %r{^\d+$}
      when [Hash]
        raise(Puppet::ParseError, "clamp(): The Hash type is not allowed (#{value})")
      end
    end

    # convert to numeric each element
    # then sort them and get a middle value
    args.map { |n| n.to_i }.sort[1]
  end
end
