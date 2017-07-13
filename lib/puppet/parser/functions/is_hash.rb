#
# is_hash.rb
#

module Puppet::Parser::Functions
  newfunction(:is_hash, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable passed to this function is a hash.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("is_hash(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size != 1

    type = arguments[0]

    result = type.is_a?(Hash)

    return result
  end
end

# vim: set ts=2 sw=2 et :
