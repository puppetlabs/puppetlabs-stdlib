# @summary Validate the value of the ensure parameter for a package
type Stdlib::Ensure::Package = Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]]
