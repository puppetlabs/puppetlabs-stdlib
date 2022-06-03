# @summary x509 parameters pem validation
type Stdlib::X509::Pem::Params = Variant[
  Stdlib::X509::Pem::DH::Params,
  Stdlib::X509::Pem::DSA::Params,
  Stdlib::X509::Pem::EC::Params,
]
