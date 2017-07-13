#
# difference.rb
#

module Puppet::Parser::Functions
  newfunction(:difference, :type => :rvalue, :doc => _(<<-EOS)
This function returns the difference between two arrays.
The returned array is a copy of the original array, removing any items that
also appear in the second array.

*Examples:*

    difference(["a","b","c"],["b","c","d"])

Would return: ["a"]
    EOS
  ) do |arguments|

    # Two arguments are required
    raise(Puppet::ParseError, _("difference(): Wrong number of arguments given (%{num_args} for 2)") % { num_args: arguments.size, }) if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, _('difference(): Requires 2 arrays'))
    end

    result = first - second

    return result
  end
end

# vim: set ts=2 sw=2 et :
