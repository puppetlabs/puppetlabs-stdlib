#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => _(<<-EOS)
This function joins an array into a string using a separator.

*Examples:*

    join(['a','b','c'], ",")

Would result in: "a,b,c"
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, _("join(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, _('join(): Requires array to work with'))
    end

    suffix = arguments[1] if arguments[1]

    if suffix
      unless suffix.is_a?(String)
        raise(Puppet::ParseError, _('join(): Requires string to work with'))
      end
    end

    result = suffix ? array.join(suffix) : array.join

    return result
  end
end

# vim: set ts=2 sw=2 et :
