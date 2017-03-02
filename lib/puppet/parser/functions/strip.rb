#
#  strip.rb
#

module Puppet::Parser::Functions
  newfunction(:strip, :type => :rvalue, :doc => _(<<-EOS)
This function removes leading and trailing whitespace from a string or from
every string inside an array.

*Examples:*

    strip("    aaa   ")

Would result in: "aaa"
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("strip(): Wrong number of arguments given (#{arguments.size} for 1)")) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('strip(): Requires either array or string to work with'))
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.strip : i }
    else
      result = value.strip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
