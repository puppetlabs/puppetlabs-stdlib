# Validate full IPv6 address without subnet
type Stdlib::IP::Address::V6::Nosubnet::Full = Pattern[/\A[[:xdigit:]]{1,4}(:[[:xdigit:]]{1,4}){7}\z/]
