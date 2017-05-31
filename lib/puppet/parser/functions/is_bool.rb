#
# is_bool.rb
#

module Puppet::Parser::Functions
  newfunction(:is_bool, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable passed to this function is a boolean.
    EOS
  ) do |arguments|

    function_deprecation([:is_bool, _('This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Bool. There is further documentation for validate_legacy function in the README.')])

    raise(Puppet::ParseError, _("is_bool(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size != 1

    type = arguments[0]

    result = type.is_a?(TrueClass) || type.is_a?(FalseClass)

    return result
  end
end
