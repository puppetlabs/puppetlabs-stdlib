# @summary Returns true if the client has the requested IPv4 address on some interface.
#
# @param ip_address
#   The IPv4 address you want to check the existence of
# @return [Boolean] Returns `true` if the requested IP address exists on any interface.
function stdlib::has_ip_address(
  Stdlib::IP::Address::V4::Nosubnet $ip_address,
) >> Boolean {
  stdlib::has_interface_with('ipaddress', $ip_address)
}
