# @summary function to cast ensure parameter to resource specific value
function stdlib::ensure(
    Variant[Boolean, Enum['present', 'absent']]               $ensure,
    Enum['directory', 'link', 'mounted', 'service', 'file'] $resource,
) >> String {
    $_ensure = $ensure ? {
        Boolean => $ensure.bool2str('present', 'absent'),
        default => $ensure,
    }
    case $resource {
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
