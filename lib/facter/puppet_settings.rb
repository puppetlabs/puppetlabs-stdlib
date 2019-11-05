# These facter facts return the value of the Puppet vardir and environment path
# settings for the node running puppet or puppet agent.  The intent is to
# enable Puppet modules to automatically have insight into a place where they
# can place variable data, or for modules running on the puppet master to know
# where environments are stored.
#
# The values should be directly usable in a File resource path attribute.
#
settings = [
  :vardir,
  :environmentpath,
  :server,
  :localcacert,
  :ssldir,
  :hostpubkey,
  :hostprivkey,
  :hostcert,
]
compat = [
  :vardir,
  :environmentpath,
  :server,
]
Facter.add(:puppet_settings) do
  puppet_settings = {}
  setcode do
    settings.each do |setting|
      puppet_settings[setting.to_s] = Puppet[setting]
    end
    puppet_settings
  end
end

compat.each do |setting|
  Facter.add("puppet_#{setting}".to_sym) do
    setcode do
      Puppet[setting]
    end
  end
end
