#
#  chop.rb
#

module Puppet::Parser::Functions
  newfunction(:chop, :type => :rvalue, :doc => _(<<-'EOS')
    Returns a new string with the last character removed. If the string ends
    with `\r\n`, both characters are removed. Applying chop to an empty
    string returns an empty string. If you wish to merely remove record
    separators then you should use the `chomp` function.
    Requires a string or array of strings as input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("chop(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('chop(): Requires either an array or string to work with'))
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.chop : i }
    else
      result = value.chop
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
