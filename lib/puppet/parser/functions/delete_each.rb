#
# delete_each.rb
#

module Puppet::Parser::Functions
  newfunction(:delete_each, :type => :rvalue, :doc => <<-EOS
Deletes an array of elements from an array.

*Examples:*
    delete_each(original_array, to_delete_array)
    delete_each(['a','b','c', 'd'], ['b'. 'd'])

Would return: ['a','c']
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "delete_each(): Wrong number of arguments "+
        "given #{arguments.size} for 2")
    end

    original_array = arguments[0]
    to_delete_array = arguments[1]

    if !original_array.kind_of?(Array) then
      raise(Puppet::ParseError, "delete_each(): first argument is not an array ")
    end
    if !to_delete_array.kind_of?(Array) then
      raise(Puppet::ParseError, "delete_each(): second argument is not an array ")
    end

    original_array.each {|entry|
      if to_delete_array.include?(entry) then
        original_array.delete(entry)
      end
    }

    original_array

  end
end

# vim: set ts=2 sw=2 et :
