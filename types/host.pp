# @summary Validate a host (FQDN or IP address)
type Stdlib::Host = Variant[Stdlib::Fqdn, Stdlib::Compat::Ip_address]
