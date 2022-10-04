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

  confine do
    Facter.value(:kernel) != 'windows'
  end

  # Instantiates a dummy package resource and return the provider
  setcode do
    if defined? Gem && Gem::Version.new(Facter.value(:puppetversion).split(' ')[0]) >= Gem::Version.new('3.6')
      Puppet::Type.type(:package).newpackage(name: 'dummy', allow_virtual: 'true')[:provider].to_s
    else
      Puppet::Type.type(:package).newpackage(name: 'dummy')[:provider].to_s
    end
  end
end

Facter.add(:package_provider) do

  confine do
    Facter.value(:kernel) == 'windows'
  end

  # do not instantiate a dummy package and also maintain backwards compat:
  # facter on windows can only return native provider which is string `windows`
  setcode do
    'windows'
  end
end
