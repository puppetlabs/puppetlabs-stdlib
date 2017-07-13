#
#  lstrip.rb
#

module Puppet::Parser::Functions
  newfunction(:lstrip, :type => :rvalue, :doc => _(<<-EOS)
Strips leading spaces to the left of a string.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("lstrip(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('lstrip(): Requires either array or string to work with'))
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.lstrip : i }
    else
      result = value.lstrip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
