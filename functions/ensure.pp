# @summary function to cast ensure parameter to resource specific value
#
# @return [String]
function stdlib::ensure(
  Variant[Boolean, Enum['present', 'absent']] $ensure,
  Enum['directory', 'link', 'mounted', 'service', 'file', 'package'] $resource,
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
    default: {
      $_ensure ? {
        'present' => $resource,
        default   => $_ensure,
      }
    }
  }
}
