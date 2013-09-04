module Puppet::Parser::Functions
  newfunction(:get_module_path, :type =>:rvalue, :arity => 1, :doc => <<-EOT
    Returns the absolute path of the specified module for the current
    environment.

    Example:
      $module_path = get_module_path('stdlib')
  EOT
  ) do |args|
    if module_path = Puppet::Module.find(args[0], compiler.environment.to_s)
      module_path.path
    else
      raise(Puppet::ParseError, "Could not find module #{args[0]} in environment #{compiler.environment}")
    end
  end
end
