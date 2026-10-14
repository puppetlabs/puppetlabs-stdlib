# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`stdlib::ensure_resource`](#stdlibensure_resource) instead.
Puppet::Functions.create_function(:ensure_resource) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'ensure_resource', 'This function is deprecated, please use stdlib::ensure_resource instead.', false)
    call_function('stdlib::ensure_resource', *args)
  end
end
