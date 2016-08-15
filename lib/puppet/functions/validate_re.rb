Puppet::Functions.create_function(:validate_re, Puppet::Functions::InternalFunction) do
  dispatch :do_call do
    scope_param
    optional_repeated_param 'Any', :args
  end

  def do_call(scope, *args)
    call_function('deprecation', 'puppet_3_type_check', 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Re. There is further documentation for validate_legacy function in the README.')
    scope.function_validate_re(args)
  end
end
