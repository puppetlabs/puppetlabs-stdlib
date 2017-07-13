#
# empty.rb
#

module Puppet::Parser::Functions
  newfunction(:empty, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable is empty.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("empty(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(Hash) || value.is_a?(String) || value.is_a?(Numeric)
      raise(Puppet::ParseError, _('empty(): Requires either array, hash, string or integer to work with'))
    end

    if value.is_a?(Numeric)
      return false
    else
      result = value.empty?

      return result
    end
  end
end

# vim: set ts=2 sw=2 et :
