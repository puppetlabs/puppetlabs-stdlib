#
#  camelcase.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#

module Puppet::Parser::Functions
  newfunction(:camelcase, :type => :rvalue, :doc => _(<<-EOS)
Converts the case of a string or all strings in an array to camel case.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("camelcase(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, _('camelcase(): Requires either array or string to work with'))
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.split('_').map{|e| e.capitalize}.join : i }
    else
      result = value.split('_').map{|e| e.capitalize}.join
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
