# Emulate the validate_ipv4_address and is_ipv4_address functions
type Stdlib::Compat::Ipv4 = Pattern[/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]
