#
# flatten.rb
#

module Puppet::Parser::Functions
  newfunction(:flatten, :type => :rvalue, :doc => _(<<-EOS)
This function flattens any deeply nested arrays and returns a single flat array
as a result.

*Examples:*

    flatten(['a', ['b', ['c']]])

Would return: ['a','b','c']
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("flatten(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size != 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, _('flatten(): Requires array to work with'))
    end

    result = array.flatten

    return result
  end
end

# vim: set ts=2 sw=2 et :
