# Fact: package_provider
#
# Purpose: Returns the default provider Puppet will choose to manage packages
#   on this system
#
# Resolution: Instantiates a dummy package resource and return the provider
#
# Caveats:
#
require 'puppet/type'
require 'puppet/type/package'

Facter.add(:package_provider) do
  setcode do
    Puppet::Type.type(:package).newpackage(:name => 'dummy')[:provider].to_s
  end
end
