# Fact: service_provider
#
# Purpose: Returns the default provider Puppet will choose to manage services
#   on this system
#
# Resolution: Instantiates a dummy service resource and return the provider
#
# Caveats:
#
Facter.add(:service_provider) do
  setcode do
    Puppet::Type.type(:service).newservice(:name => 'dummy')[:provider].to_s
  end
end
