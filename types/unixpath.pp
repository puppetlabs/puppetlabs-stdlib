# this regex rejects any path component that does not start with "/" or is NUL
type Stdlib::Unixpath = Pattern[/\A\/([^\n\/\0]+\/*)*\z/]
