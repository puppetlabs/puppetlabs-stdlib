#
# hash.rb
#
module Puppet::Parser::Functions
  newfunction(:hash, :type => :rvalue, :doc => <<-DOC
    This function converts an array into a hash.

    *Examples:*

        hash(['a',1,'b',2,'c',3])

    Would return: {'a'=>1,'b'=>2,'c'=>3}

    Note: Since Puppet 5.0.0 type conversions can in general be performed by using the Puppet Type System.
    See the function new() in Puppet for a wide range of available type conversions.
    This example shows the equivalent expression in the Puppet language:

        Hash(['a',1,'b',2,'c',3])
        Hash([['a',1],['b',2],['c',3]])
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "hash(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'hash(): Requires array to work with')
    end

    result = {}

    begin
      # This is to make it compatible with older version of Ruby ...
      array  = array.flatten
      result = Hash[*array]
    rescue StandardError
      raise(Puppet::ParseError, 'hash(): Unable to compute hash from array given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
