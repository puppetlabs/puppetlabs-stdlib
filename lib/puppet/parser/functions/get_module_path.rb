module Puppet::Parser::Functions
  newfunction(:get_module_path, :type =>:rvalue, :doc => _(<<-EOT)
    Returns the absolute path of the specified module for the current
    environment.

    Example:
      $module_path = get_module_path('stdlib')
  EOT
  ) do |args|
    raise(Puppet::ParseError, _("get_module_path(): Wrong number of arguments, expects one")) unless args.size == 1
    if module_path = Puppet::Module.find(args[0], compiler.environment.to_s)
      module_path.path
    else
      raise(Puppet::ParseError, _("Could not find module %{module_name} in environment %{env_name}") % { module_name: args[0], env_name: compiler.environment })
    end
  end
end
