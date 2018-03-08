# this regex rejects any path component that does not start with "/" or is NUL
type Stdlib::Unixpath::Absolute = Pattern[/^\/([^\/\0]+\/*)*$/]
