#
# concat.rb
#

module Puppet::Parser::Functions
  newfunction(:concat, :type => :rvalue, :doc => _(<<-EOS)
Appends the contents of multiple arrays into array 1.

*Example:*

    concat(['1','2','3'],['4','5','6'],['7','8','9'])

Would result in:

  ['1','2','3','4','5','6','7','8','9']
    EOS
  ) do |arguments|

    # Check that more than 2 arguments have been given ...
    raise(Puppet::ParseError, _("concat(): Wrong number of arguments given (%{num_args} for < 2)") % { num_args: arguments.size, }) if arguments.size < 2

    a = arguments[0]

    # Check that the first parameter is an array
    unless a.is_a?(Array)
      raise(Puppet::ParseError, _('concat(): Requires array to work with'))
    end

    result = a
    arguments.shift

    arguments.each do |x|
      result = result + (x.is_a?(Array) ? x : [x])
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
