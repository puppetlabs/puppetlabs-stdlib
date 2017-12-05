# this regex rejects any path component that does not start with "/", contain a "." or is NUL
type Stdlib::Unixpath = Pattern[/^\/([^\/\0]+\/*)*$/]
