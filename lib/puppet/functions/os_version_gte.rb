# Checks if the OS version is at least a certain version. Note that only the
# major version is taken into account.
#
# Example usage:
#
#     if os_version_gte('Debian', '9') { }
#     if os_version_gte('Ubuntu', '18.04') { }
Puppet::Functions.create_function(:os_version_gte) do
  dispatch :os_version_gte do
    param 'String[1]', :os
    param 'String[1]', :version
    return_type 'Boolean'
  end

  def os_version_gte(os, version)
    facts = closure_scope['facts']
    (facts['operatingsystem'] == os &&
     Puppet::Util::Package.versioncmp(version, facts['operatingsystemmajrelease']) >= 0)
  end
end
