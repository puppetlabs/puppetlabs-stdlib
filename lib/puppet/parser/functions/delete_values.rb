#
# delete_values.rb
#
module Puppet::Parser::Functions
  newfunction(:delete_values, :type => :rvalue, :doc => <<-DOC
    @summary
      Deletes all instances of a given value from a hash.

    @example Example usage

      delete_values({'a'=>'A','b'=>'B','c'=>'C','B'=>'D'}, 'B')
      Would return: {'a'=>'A','c'=>'C','B'=>'D'}

    > *Note:*
    Since Puppet 4.0.0 the equivalent can be performed with the
    built-in [`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:
    $array.filter |$val| { $val != 'B' }
    $hash.filter |$key, $val| { $val != 'B' }

    @return [Hash] The given hash now missing all instances of the targeted value
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "delete_values(): Wrong number of arguments given (#{arguments.size} of 2)") if arguments.size != 2

    hash, item = arguments

    unless hash.is_a?(Hash)
      raise(TypeError, "delete_values(): First argument must be a Hash. Given an argument of class #{hash.class}.")
    end
    hash.dup.delete_if { |_key, val| item == val }
  end
end
