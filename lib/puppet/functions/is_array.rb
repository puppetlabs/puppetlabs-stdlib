Puppet::Functions.create_function(:is_array, Puppet::Functions::InternalFunction) do
  dispatch :deprecation_gen do
    scope_param
    optional_repeated_param 'Any', :args
  end
  def deprecation_gen(scope, *args)
    call_function('deprecation', 'is_array', "This method is deprecated, please use match expressions with Stdlib::Compat::Array instead. They are described at https://docs.puppet.com/puppet/latest/reference/lang_data_type.html#match-expressions.")
    scope.send("function_is_array", args)
  end
end
