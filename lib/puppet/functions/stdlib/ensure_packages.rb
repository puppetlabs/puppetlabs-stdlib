# frozen_string_literal: true

# @summary Takes a list of packages and only installs them if they don't already exist.
#
# It optionally takes a hash as a second parameter that will be passed as the
# third argument to the ensure_resource() function.
Puppet::Functions.create_function(:'stdlib::ensure_packages', Puppet::Functions::InternalFunction) do
  # @param packages
  #   The packages to ensure are installed.
  # @param default_attributes
  #   Default attributes to be passed to the `ensure_resource()` function
  # @return [Undef] Returns nothing.
  dispatch :ensure_packages do
    scope_param
    param 'Variant[String[1], Array[String[1]]]', :packages
    optional_param 'Hash', :default_attributes
    return_type 'Undef'
  end

  # @param packages
  #   The packages to ensure are installed. The keys are packages and values are the attributes specific to that package.
  # @param default_attributes
  #   Default attributes. Package specific attributes from the `packages` parameter will take precedence.
  # @return [Undef] Returns nothing.
  dispatch :ensure_packages_hash do
    scope_param
    param 'Hash[String[1], Any]', :packages
    optional_param 'Hash', :default_attributes
    return_type 'Undef'
  end

  def ensure_packages(scope, packages, default_attributes = {})
    Array(packages).each do |package_name|
      defaults = { 'ensure' => 'installed' }.merge(default_attributes)

      # `present` and `installed` are aliases for the `ensure` attribute. If `ensure` is set to either of these values replace
      # with `installed` by default but `present` if this package is already in the catalog with `ensure => present`
      defaults['ensure'] = default_ensure(package_name) if ['present', 'installed'].include?(defaults['ensure'])

      scope.call_function('ensure_resource', ['package', package_name, defaults])
    end
    nil
  end

  def ensure_packages_hash(scope, packages, default_attributes = {})
    packages.each do |package, attributes|
      ensure_packages(scope, package, default_attributes.merge(attributes))
    end
    nil
  end

  private

  def default_ensure(package_name)
    if call_function('defined_with_params', "Package[#{package_name}]", { 'ensure' => 'present' })
      'present'
    else
      'installed'
    end
  end
end
