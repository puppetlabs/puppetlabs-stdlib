# Validate an IPv4 address
type Stdlib::IP::Address::V4 = Variant[
  Stdlib::IP::Address::V4::CIDR,
  Stdlib::IP::Address::V4::Nosubnet,
]
