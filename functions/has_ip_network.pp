# @summary Returns true if the client has the requested IPv4 network on some interface.
#
# @param ip_network
#   The IPv4 network you want to check the existence of
# @return [Boolean] Returns `true` if the requested IP network exists on any interface.
function stdlib::has_ip_network(
  Stdlib::IP::Address::V4::Nosubnet $ip_network,
) >> Boolean {
  stdlib::has_interface_with('network', $ip_network)
}
