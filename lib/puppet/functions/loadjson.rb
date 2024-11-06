# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`stdlib::loadjson`](#stdlibloadjson) instead.
Puppet::Functions.create_function(:loadjson, Puppet::Functions::InternalFunction) do
  dispatch :deprecation_gen do
    scope_param
    repeated_param 'Any', :args
  end
  def deprecation_gen(scope, *args)
    call_function('deprecation', 'loadjson', 'This function is deprecated, please use stdlib::loadjson instead.', false)
    scope.call_function('stdlib::loadjson', args)
  end
end
