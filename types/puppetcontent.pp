# this regex rejects any path component that is a / or a NUL
type Stdlib::Puppetcontent = Pattern[/^([^\/\0]+(\/)?)+$/]
