# frozen_string_literal: true

module Puppet::Parser::Functions
  newfunction(:ensure_packages, type: :statement, doc: '@summary Deprecated 3x version of the `ensure_packages` function') do |arguments|
    # Call the 4.x version of this function in case 3.x ruby code uses this function
    Puppet.warn_once('deprecations', '3xfunction#ensure_packages', 'Calling function_ensure_packages via the Scope class is deprecated. Use Scope#call_function instead')
    call_function('ensure_packages', arguments)
  end
end
