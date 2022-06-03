# @summary x509 RSA pem validation
type Stdlib::X509::Pem::RSA = Variant[
  Stdlib::X509::Pem::RSA::Private,
  Stdlib::X509::Pem::RSA::Public,
]
