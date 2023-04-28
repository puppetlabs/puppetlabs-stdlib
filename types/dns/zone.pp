# @summary Validate a DNS zone name
type Stdlib::Dns::Zone = Pattern[/\A((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.)+|\.)\z/]
