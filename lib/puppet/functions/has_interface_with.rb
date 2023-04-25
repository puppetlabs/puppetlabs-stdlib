# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`stdlib::has_interface_with`](#stdlibhas_interface_with) instead.
Puppet::Functions.create_function(:has_interface_with) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'has_interface_with', 'This method is deprecated, please use stdlib::has_interface_with instead.')
    call_function('stdlib::has_interface_with', *args)
  end
end
