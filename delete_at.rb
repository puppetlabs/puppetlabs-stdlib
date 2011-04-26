#
# delete_at.rb
#

module Puppet::Parser::Functions
  newfunction(:delete_at, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "delete_at(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'delete_at(): Requires an array to work with')
    end

    index = arguments[1]

    if not index.match(/^\d+$/)
      raise(Puppet::ParseError, 'delete_at(): You must provide ' +
        'positive numeric index')
    end

    result = array.clone

    # In Puppet numbers are often string-encoded ...
    index = index.to_i

    if index > result.size - 1 # First element is at index 0 is it not?
      raise(Puppet::ParseError, 'delete_at(): Given index ' +
        'exceeds array size')
    end

    result.delete_at(index) # We ignore the element that got deleted ...

    return result
  end
end

# vim: set ts=2 sw=2 et :
