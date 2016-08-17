# Emulate the validate_ipv4_address and is_ipv4_address functions
type Stdlib::Compat::Ipv4 = Pattern[/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/]
