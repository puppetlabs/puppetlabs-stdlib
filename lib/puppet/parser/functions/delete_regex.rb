#
# delete_regex.rb
#

module Puppet::Parser::Functions
  newfunction(:delete_regex, :type => :rvalue, :doc => <<-EOS
deletes all instances of a given element that match a regular expression
from an array or key from a hash. Multiple regular expressions are assumed
to be matched as an OR.

*Examples:*

    delete_regex(['a','b','c','b'], 'b')
    Would return: ['a','c']
    
    delete_regex(['a','b','c','b'], ['b', 'c'])
    Would return: ['a']

    delete_regex({'a'=>1,'b'=>2,'c'=>3}, 'b')
    Would return: {'a'=>1,'c'=>3}

    delete_regex({'a'=>1,'b'=>2,'c'=>3}, '^a$')
    Would return: {'b'=>2,'c'=>3}

  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "delete_regex(): Wrong number of arguments "+
                              "given #{arguments.size} for 2") unless arguments.size == 2

    collection = arguments[0].dup
    Array(arguments[1]).each do |item|
      case collection
        when Array, Hash, String
          collection.reject! { |coll_item| (coll_item =~ %r{\b#{item}\b}) }
        else
          raise(TypeError, "delete_regex(): First argument must be an Array, " +
                             "Hash, or String. Given an argument of class #{collection.class}.")
      end
    end
    collection
  end
end

# vim: set ts=2 sw=2 et :
