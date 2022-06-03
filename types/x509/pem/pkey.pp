# @summary x509 key pem validation
type Stdlib::X509::Pem::Pkey = Variant[
  Stdlib::X509::Pem::Pkey::Public,
  Stdlib::X509::Pem::Pkey::Private,
]
