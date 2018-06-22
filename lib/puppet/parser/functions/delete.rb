#
# delete.rb
#
module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => <<-DOC
    Deletes all instances of a given element from an array, substring from a
    string, or key from a hash.

    *Examples:*

        delete(['a','b','c','b'], 'b')
        Would return: ['a','c']

        delete({'a'=>1,'b'=>2,'c'=>3}, 'b')
        Would return: {'a'=>1,'c'=>3}

        delete({'a'=>1,'b'=>2,'c'=>3}, ['b','c'])
        Would return: {'a'=>1}

        delete('abracadabra', 'bra')
        Would return: 'acada'

    Note that from Puppet 4.0.0 the minus (-) operator deletes values from arrays and keys from a hash:

        ['a', 'b', 'c', 'b'] - 'b'
        # would return ['a', 'c']

        {'a'=>1,'b'=>2,'c'=>3} - ['b','c'])
        # would return {'a' => '1'}

    A global delete from a string can be performed with the regsubst() function:

        'abracadabra'.regsubst(/bra/, '', 'G')
        # would return 'acada'

    In general, the filter() function can filter out entries from arrays and hashes based on keys and/or values.

  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "delete(): Wrong number of arguments given #{arguments.size} for 2") unless arguments.size == 2

    collection = arguments[0].dup
    Array(arguments[1]).each do |item|
      case collection
      when Array, Hash
        collection.delete item
      when String
        collection.gsub! item, ''
      else
        raise(TypeError, "delete(): First argument must be an Array, String, or Hash. Given an argument of class #{collection.class}.")
      end
    end
    collection
  end
end

# vim: set ts=2 sw=2 et :
