#
# is_function_available.rb
#

module Puppet::Parser::Functions
  newfunction(:is_function_available, :type => :rvalue, :doc => _(<<-EOS)
This function accepts a string as an argument, determines whether the
Puppet runtime has access to a function by that name.  It returns a
true if the function exists, false if not.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, _("is_function_available?(): Wrong number of arguments given %{num_args} for 1") % { num_args: arguments.size })
    end

    # Only allow String types
    return false unless arguments[0].is_a?(String)

    function = Puppet::Parser::Functions.function(arguments[0].to_sym)
    function.is_a?(String) and not function.empty?
  end
end

# vim: set ts=2 sw=2 et :
