module Puppet::Parser::Functions
  newfunction(:deprecation, :doc => _(<<-EOS)
  Function to print deprecation warnings (this is the 3.X version of it), The uniqueness key - can appear once. The msg is the message text including any positional information that is formatted by the user/caller of the method.).
EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("deprecation: Wrong number of arguments given (%{num_args} for 2)") % { num_args: arguments.size }) unless arguments.size == 2

    key = arguments[0]
    message = arguments[1]

    if ENV['STDLIB_LOG_DEPRECATIONS'] == "true"
      warning(_("deprecation. %{key}. %{message}") % { key: key, message: message })
    end
  end
end
