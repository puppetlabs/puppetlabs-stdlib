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
# @example To specify a specific provider:
#   # Ensure at least version 2.7.5-77.el7_6 of python is installed
#     package { 'openssl':
#       ensure   => ensure_at_least('openssl', '2.1.2', 'gem'),
#       provider => gem
#     }
#
Puppet::Functions.create_function(:ensure_at_least) do
  # @param package
  #   The package to ensure
  #
  # @param minversion
  #   The minimum version to ensure
  #
  # @param provider
  #   (Optional) The provider to use
  #
  # @return [String] package version value.
  dispatch :ensure_at_least do
    required_param 'String', :package
    required_param 'String', :minversion
    optional_param 'String', :provider
    return_type 'String'
  end

  def ensure_at_least(package, minversion, provider = nil)
    trusted = closure_scope['trusted']
    query = [
      'package_inventory[version] {',
      "certname = '#{trusted['certname']}'",
      "and package_name = '#{package}'",
      ("and provider = '#{provider}'" unless provider.nil?),
      '}',
    ].compact.join(' ')

    queryresult = call_function('puppetdb_query', query)
    case queryresult.length
    when 0
      result = { 'version' => '0.0.0' }
    when 1
      result = queryresult.first
    when 2..Float::INFINITY
      if provider.nil?
        # Assume first PDB query result is for the default provider
        provider = queryresult.map { |elem| elem['provider'] }.first
      end
      # Assume last PDB query result is always the highest version
      result = queryresult.select { |elem| elem['provider'] == provider }.last
    else
      result = { 'version' => '0.0.0' }
    end

    installed = result['version']

    case call_function('versioncmp', installed, minversion)
    when 0, 1
      installed
    when -1
      minversion
    else
      minversion
    end
  end
end
