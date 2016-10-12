Puppet::Functions.create_function(:validate_absolute_path, Puppet::Functions::InternalFunction) do
  dispatch :deprecation_gen do
    scope_param
    optional_repeated_param 'Any', :args
  end
  def deprecation_gen(scope, *args)
    call_function('deprecation', 'validate_absolute_path', "This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Absolute_Path. There is further documentation for validate_legacy function in the README.")
    scope.send("function_validate_absolute_path", args)
  end
end
