# frozen_string_literal: true

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

# These will be nil if Puppet is not available.
Facter.add(:package_provider) do
  # Instantiates a dummy package resource and return the provider
  setcode do
    Puppet::Type.type(:package).newpackage(name: 'dummy', allow_virtual: 'true')[:provider].to_s
  end
end
