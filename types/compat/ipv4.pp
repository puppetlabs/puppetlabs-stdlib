# Emulate the validate_ipv4_address and is_ipv4_address functions
type Stdlib::Compat::Ipv4 = Pattern[/^(([0-9](?!\d)|[1-9][0-9](?!\d)|1[0-9]{2}(?!\d)|2[0-4][0-9](?!\d)|25[0-5](?!\d))[.]?){4}$/]
