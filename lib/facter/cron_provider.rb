# Fact: cron_provider
#
# Purpose: Returns the default provider Puppet will choose to manage cron
#   on this system
#
# Resolution: Instantiates a dummy cron resource and return the provider
#
# Caveats:
#
require 'puppet/type'
require 'puppet/type/cron'

Facter.add(:cron_provider) do
  setcode do
    provider = Puppet::Type.type(:cron).newcron(:name => 'dummy')[:provider]
    provider.to_s if provider
  end
end
