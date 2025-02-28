# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`stdlib::ensure_resources`](#stdlibensure_resources) instead.
Puppet::Functions.create_function(:ensure_resources) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'ensure_resources', 'This function is deprecated, please use stdlib::ensure_resources instead.', false)
    call_function('stdlib::ensure_resources', *args)
  end
end
