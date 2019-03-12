# https://puppet.com/docs/puppet/latest/type.html#package-attribute-ensure
type Stdlib::Ensure::Package = Enum[
  'present',
  'installed',
  'absent',
  'purged',
  'held',
  'latest',
]
