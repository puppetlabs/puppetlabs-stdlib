#
# is_array.rb
#

module Puppet::Parser::Functions
  newfunction(:is_array, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable passed to this function is an array.
    EOS
  ) do |arguments|

    function_deprecation([:is_array, _('This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Array. There is further documentation for validate_legacy function in the README.')])

    raise(Puppet::ParseError, _("is_array(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size < 1

    type = arguments[0]

    result = type.is_a?(Array)

    return result
  end
end
