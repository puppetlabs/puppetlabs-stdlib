#
# assert_private.rb
#

module Puppet::Parser::Functions
  newfunction(:assert_private, :doc => _(<<-'EOS')
    Sets the current class or definition as private.
    Calling the class or definition from outside the current module will fail.
    EOS
  ) do |args|

    raise(Puppet::ParseError, _("assert_private(): Wrong number of arguments given (%{num_args}) for 0 or 1)") % { num_args: args.size }) if args.size > 1

    scope = self
    if scope.lookupvar('module_name') != scope.lookupvar('caller_module_name')
      message = nil
      if args[0] and args[0].is_a? String
        message = args[0]
      else
        manifest_name = scope.source.name
        manifest_type = scope.source.type
        message = (manifest_type.to_s == 'hostclass') ? 'Class' : 'Definition'
        message += _(" %{manifest_name} is private") % { manifest_name: manifest_name }
      end
      raise(Puppet::ParseError, message)
    end
  end
end
