#
#  rstrip.rb
#

module Puppet::Parser::Functions
  newfunction(:rstrip, :type => :rvalue, :doc => _(<<-EOS)
Strips leading spaces to the right of the string.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("rstrip(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('rstrip(): Requires either array or string to work with'))
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.rstrip : i }
    else
      result = value.rstrip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
