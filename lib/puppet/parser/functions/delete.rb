#
# delete.rb
#

module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => _(<<-EOS)
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
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("delete(): Wrong number of arguments given %{num_args} for 2") % { num_args: arguments.size, }) unless arguments.size == 2

    collection = arguments[0].dup
    Array(arguments[1]).each do |item|
      case collection
        when Array, Hash
          collection.delete item
        when String
          collection.gsub! item, ''
        else
          raise(TypeError, _("delete(): First argument must be an Array, String, or Hash. Given an argument of class %{arg_class}.") % { arg_class: collection.class, })
      end
    end
    collection
  end
end

# vim: set ts=2 sw=2 et :
