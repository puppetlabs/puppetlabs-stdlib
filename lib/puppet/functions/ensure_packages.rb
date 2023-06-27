# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`stdlib::ensure_packages`](#stdlibensure_packages) instead.
Puppet::Functions.create_function(:ensure_packages, Puppet::Functions::InternalFunction) do
  dispatch :deprecation_gen do
    scope_param
    repeated_param 'Any', :args
  end
  def deprecation_gen(scope, *args)
    call_function('deprecation', 'ensure_packages', 'This function is deprecated, please use stdlib::ensure_packages instead.', false)
    scope.call_function('stdlib::ensure_packages', args)
  end
end
