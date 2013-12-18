#
# concat.rb
#

module Puppet::Parser::Functions
  newfunction(:add, :type => :rvalue, :doc => <<-EOS
Appends the contents of array 2 onto array 1.

*Example:*

    a = add(['1','2','3'],['4','5','6'])

Would result in a being:

  ['1','2','3','4','5','6']
    EOS
  ) do |arguments|

    # Check that 2 arguments have been given ...
    raise(Puppet::ParseError, "add(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size != 2

    a = arguments[0]
    b = arguments[1]

    # Check that both args are arrays.
    unless a.is_a?(Array) and b.is_a?(Array)
      raise(Puppet::ParseError, 'add(): Requires array to work with')
    end

    result = a + b

    return result
  end
end

# vim: set ts=2 sw=2 et :
