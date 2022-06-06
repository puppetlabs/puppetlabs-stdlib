# @summary Validate the value of the ensure parameter for a file
type Stdlib::Ensure::File = Enum['present', 'file', 'directory', 'link', 'absent']
