# Simply return an array of all PE profiles this node is classified with.
# Clearly subject to a chicken and egg, but there's probably not a better way.
Facter.add(:pe_roles) do
  setcode do
    begin
      classes = File.readlines(Puppet.settings[:classfile])
      classes = classes.grep(/puppet_enterprise::profile::([^:]*)$/) { |cl| $1.chomp }
      classes.uniq
    rescue
      nil
    end
  end
end
