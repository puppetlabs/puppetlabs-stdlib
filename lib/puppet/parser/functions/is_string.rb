#
# is_string.rb
#

module Puppet::Parser::Functions
  newfunction(:is_string, :type => :rvalue, :doc => _(<<-EOS)
Returns true if the variable passed to this function is a string.
    EOS
  ) do |arguments|

    function_deprecation([:is_string, _('This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::String. There is further documentation for validate_legacy function in the README.')])

    raise(Puppet::ParseError, _("is_string(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size, }) if arguments.size < 1

    type = arguments[0]

    # when called through the v4 API shim, undef gets translated to nil
    result = type.is_a?(String) || type.nil?

    if result and (type == type.to_f.to_s or type == type.to_i.to_s) then
      return false
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
