#
# hash.rb
#

module Puppet::Parser::Functions
  newfunction(:hash, :type => :rvalue, :doc => _(<<-EOS)
This function converts an array into a hash.

*Examples:*

    hash(['a',1,'b',2,'c',3])

Would return: {'a'=>1,'b'=>2,'c'=>3}
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("hash(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size < 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, _('hash(): Requires array to work with'))
    end

    result = {}

    begin
      # This is to make it compatible with older version of Ruby ...
      array  = array.flatten
      result = Hash[*array]
    rescue StandardError
      raise(Puppet::ParseError, _('hash(): Unable to compute hash from array given'))
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
