# @summary validate an dsa validation
type Stdlib::X509::Pem::DSA = Variant[
  Stdlib::X509::Pem::DSA::Private,
  Stdlib::X509::Pem::DSA::Public,
  Stdlib::X509::Pem::DSA::Params,
]
