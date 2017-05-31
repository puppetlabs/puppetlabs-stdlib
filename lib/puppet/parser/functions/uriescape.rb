#
#  uriescape.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
require 'uri'

module Puppet::Parser::Functions
  newfunction(:uriescape, :type => :rvalue, :doc => _(<<-EOS)
    Urlencodes a string or array of strings.
    Requires either a single string or an array as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("uriescape(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('uriescape(): Requires either array or string to work with'))
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? URI.escape(i) : i }
    else
      result = URI.escape(value)
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
