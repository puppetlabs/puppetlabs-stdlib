# frozen_string_literal: true

# root_home.rb
module Facter::Util::RootHome
  # @summary
  #   A facter fact to determine the root home directory.
  #   This varies on PE supported platforms and may be
  #   reconfigured by the end user.
  class << self
    # determines the root home directory
    def returnt_root_home
      root_ent = Facter::Util::Resolution.exec('getent passwd root')
      # The home directory is the sixth element in the passwd entry
      # If the platform doesn't have getent, root_ent will be nil and we should
      # return it straight away.
      root_ent && root_ent.split(':')[5]
    end
  end
end

Facter.add(:root_home) do
  setcode { Facter::Util::RootHome.returnt_root_home }
end

Facter.add(:root_home) do
  confine kernel: :darwin
  setcode do
    str = Facter::Util::Resolution.exec('dscacheutil -q user -a name root')
    hash = {}
    str.split("\n").each do |pair|
      key, value = pair.split(%r{:})
      hash[key] = value
    end
    hash['dir'].strip
  end
end

Facter.add(:root_home) do
  confine kernel: :aix
  root_home = nil
  setcode do
    str = Facter::Util::Resolution.exec('lsuser -c -a home root')
    str.split("\n").each do |line|
      next if %r{^#}.match?(line)
      root_home = line.split(%r{:})[1]
    end
    root_home
  end
end
