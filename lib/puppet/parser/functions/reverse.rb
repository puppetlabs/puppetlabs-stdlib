#
# reverse.rb
#

module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => _(<<-EOS)
Reverses the order of a string or array.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("reverse(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('reverse(): Requires either array or string to work with'))
    end

    result = value.reverse

    return result
  end
end

# vim: set ts=2 sw=2 et :
