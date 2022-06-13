# frozen_string_literal: true

# @summary Takes a list of packages and only installs them if they don't already exist.
#
# It optionally takes a hash as a second parameter that will be passed as the
# third argument to the ensure_resource() function.
Puppet::Functions.create_function(:ensure_packages, Puppet::Functions::InternalFunction) do
  # @param packages
  #   The packages to ensure are installed. If it's a Hash it will be passed to `ensure_resource`
  # @param default_attributes
  #   Default attributes to be passed to the `ensure_resource()` function
  # @return [Undef] Returns nothing.
  dispatch :ensure_packages do
    scope_param
    param 'Variant[String[1], Array[String[1]], Hash[String[1], Any]]', :packages
    optional_param 'Hash', :default_attributes
    return_type 'Undef'
  end

  def ensure_packages(scope, packages, default_attributes = nil)
    if default_attributes
      defaults = { 'ensure' => 'installed' }.merge(default_attributes)
      if defaults['ensure'] == 'present'
        defaults['ensure'] = 'installed'
      end
    else
      defaults = { 'ensure' => 'installed' }
    end

    if packages.is_a?(Hash)
      scope.call_function('ensure_resources', ['package', packages.dup, defaults])
    else
      Array(packages).each do |package_name|
        scope.call_function('ensure_resource', ['package', package_name, defaults])
      end
    end
    nil
  end
end
