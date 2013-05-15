#
# intersect.rb
#

module Puppet::Parser::Functions
  newfunction(:intersect, :type => :rvalue, :doc => <<-EOS
This function Intersects two arrays.

*Examles:*

    intersect(['a','b','c'], ['p','a','b])

Will return: ['a','b']
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "intersect(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array1 = arguments[0]

    unless array1.is_a?(Array)
      raise(Puppet::ParseError, 'intersect(): Requires array to work with')
    end

    array2 = arguments[1] if arguments[1]

    unless array2.is_a?(Array)
        raise(Puppet::ParseError, 'intersect(): Requires array to work with')
      end

    # Return the set intersection of the two arrays

    return array1 & array2
  end
end

