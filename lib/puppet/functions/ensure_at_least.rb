# @summary
#   Return the package version for a given package that is at least the given minimum version
#   The function will compare the currently installed package with the given minimum version and:
#    - return the minimum version if the installed package is less than the minimum version, or not present
#    - return the installed version if the installed package is the same or newer than the minimum version
#
# @example Example usage:
#   # Ensure at least version 2.7.5-77.el7_6 of python is installed
#     package { 'python':
#       ensure => ensure_at_least('python', '2.7.5-77.el7_6')
#     }
#
Puppet::Functions.create_function(:ensure_at_least, Puppet::Functions::InternalFunction) do
  # @param package
  #   The package to ensure
  #
  # @param minversion
  #   The minimum version to ensure
  #
  # @return [String] package version value.
  dispatch :ensure_at_least do
    scope_param
    required_param 'String', :package
    required_param 'String', :minversion
    return_type 'String'
  end

  def ensure_at_least(package, minversion)
    trusted = closure_scope['trusted']
    query = "package_inventory[version] {
                certname = '#{trusted['certname']}' and
                package_name = '#{package}'
              }"

    installed = call_function('puppetdb_query', query).map { |elem| elem['version'] }.first

    if installed
      case call_function('versioncmp', installed, minversion)
      when 0, 1
        installed
      when -1
        minversion
      end
    else
      minversion
    end
  end
end
