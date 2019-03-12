# https://puppet.com/docs/puppet/latest/type.html#file-attribute-ensure
type Stdlib::Ensure::File = Enum[
  'present',
  'absent',
  'file',
  'directory',
  'link',
]
