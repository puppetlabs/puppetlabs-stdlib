# Turns puppet's agent side vardir configuration setting into a fact so we can use it
# in our manifests.

Facter.add(:vardir) do
  setcode do
    if defined?(Puppet)
      Puppet[:vardir]
    end
  end
end
