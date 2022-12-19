# @summary function to cast ensure parameter to resource specific value
#
# @return [String]
function stdlib::ensure(
  Variant[Boolean, Enum['present', 'absent']] $ensure,
  Optional[Enum['directory', 'link', 'mounted', 'service', 'file', 'package']] $resource = undef,
) >> String {
  $_ensure = $ensure ? {
    Boolean => $ensure.bool2str('present', 'absent'),
    default => $ensure,
  }
  case $resource {
    'package': {
      $_ensure ? {
        'present' => 'installed',
        default   => 'absent',
      }
    }
    'service': {
      $_ensure ? {
        'present' => 'running',
        default   => 'stopped',
      }
    }
    undef: { $_ensure }
    default: {
      $_ensure ? {
        'present' => $resource,
        default   => $_ensure,
      }
    }
  }
}
