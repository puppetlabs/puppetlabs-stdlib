# @summary Validate an IP address
type Stdlib::IP::Address = Variant[
  Stdlib::IP::Address::V4,
  Stdlib::IP::Address::V6,
]
