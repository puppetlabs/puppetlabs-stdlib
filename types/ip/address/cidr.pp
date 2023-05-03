# Validate an IP address with subnet
type Stdlib::IP::Address::CIDR = Variant[
  Stdlib::IP::Address::V4::CIDR,
  Stdlib::IP::Address::V6::CIDR,
]
